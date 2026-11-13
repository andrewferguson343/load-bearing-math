defmodule AlgorithmsForOptimizationWeb.CanonicalHost do
  @moduledoc """
  Permanently redirects `www.<host>` to the bare domain, keeping the path and query string.

  The bare domain (the endpoint's configured `url: [host: ...]`, e.g. loadbearingmath.com) is
  the canonical one: canonical tags, the sitemap and Open Graph URLs all use it, so serving
  the same pages on `www` would split them in search results. Plugged at the top of the
  endpoint so the redirect happens before static files, sessions or the router.
  """
  @behaviour Plug

  import Plug.Conn

  alias AlgorithmsForOptimizationWeb.Endpoint

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{host: "www." <> rest} = conn, _opts) do
    canonical = Endpoint.host()

    if rest == canonical do
      location =
        Endpoint.url() <>
          conn.request_path <>
          if(conn.query_string == "", do: "", else: "?" <> conn.query_string)

      conn
      |> put_resp_header("location", location)
      |> send_resp(:moved_permanently, "")
      |> halt()
    else
      conn
    end
  end

  def call(conn, _opts), do: conn
end
