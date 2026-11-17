defmodule AlgorithmsForOptimizationWeb.PageViewController do
  @moduledoc """
  Receives page view beacons from `assets/js/page_views.js` and shows the private totals.

  `create/2` always answers 204, whether the view was counted or not, so anyone poking at the
  endpoint learns nothing. A view is only counted when the path is one this site actually
  serves, the user agent isn't an obvious bot, and the visitor is under the rate limit. The IP
  is used for rate limiting in memory only and never stored.
  """
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.Analytics
  alias AlgorithmsForOptimizationWeb.{ClientIP, RateLimiter, Router}

  # Paths that are real routes but not pages a reader visits.
  @excluded_prefixes ~w(/api /dev /health /robots.txt /sitemap.xml /page-views /topic-suggestions /tutoring-inquiries /work-inquiries)

  @bot_pattern ~r/bot|crawl|spider|slurp|headless|lighthouse|preview|monitor/i

  def create(conn, params) do
    with path when is_binary(path) <- params["path"],
         true <- countable_path?(path),
         false <- bot?(conn),
         :ok <- RateLimiter.hit({:page_view, ClientIP.get(conn)}, rate_limit()) do
      Analytics.record(path, referrer_host(conn, params["referrer"]))
    end

    send_resp(conn, 204, "")
  end

  def index(conn, _params) do
    summary = Analytics.summary()
    counts = Enum.map(summary.by_day, &elem(&1, 1))

    render(conn, :index,
      page_title: "Page views",
      summary: summary,
      today: List.last(counts, 0),
      average: div(summary.total, max(length(counts), 1)),
      peak: Enum.max(counts, fn -> 0 end),
      top_page: with([{path, _views} | _] <- summary.top_pages, do: path, else: (_ -> nil))
    )
  end

  defp countable_path?(path) do
    String.starts_with?(path, "/") and byte_size(path) <= 255 and
      not Enum.any?(@excluded_prefixes, &String.starts_with?(path, &1)) and
      match?(%{}, Phoenix.Router.route_info(Router, "GET", path, nil))
  end

  defp bot?(conn) do
    case get_req_header(conn, "user-agent") do
      [ua | _] -> Regex.match?(@bot_pattern, ua)
      [] -> true
    end
  end

  # Only the host of an outside referrer is kept; links within the site count as direct.
  defp referrer_host(conn, referrer) when is_binary(referrer) do
    with %URI{host: host} when is_binary(host) and host != "" <- URI.parse(referrer),
         host = host |> String.downcase() |> String.trim_leading("www."),
         false <- host == String.trim_leading(conn.host, "www."),
         true <- byte_size(host) <= 255 do
      host
    else
      _ -> ""
    end
  end

  defp referrer_host(_conn, _referrer), do: ""

  defp rate_limit,
    do: Application.fetch_env!(:algorithms_for_optimization, :page_view_rate_limit)
end
