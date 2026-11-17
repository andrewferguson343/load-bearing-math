defmodule AlgorithmsForOptimization.Analytics do
  @moduledoc """
  First-party, privacy-preserving page view counts.

  Only aggregates are stored: how many times each path was viewed on each day, split by the
  host that referred the visitor. No IP addresses, cookies, user agents or per-visitor records,
  so nothing here can identify or follow a person. The browser side lives in
  `assets/js/page_views.js` and the endpoint in `AlgorithmsForOptimizationWeb.PageViewController`.
  """

  import Ecto.Query

  alias AlgorithmsForOptimization.{PageView, Repo}

  # Both columns are varchar(255).
  @max_length 255

  @doc """
  Counts one view of `path` (referred by `referrer_host`, `""` for none) on `day`.
  Returns `:ok`, or `{:error, :invalid}` for a path or host that can't be stored.
  """
  def record(path, referrer_host \\ "", day \\ Date.utc_today())

  def record(path, referrer_host, %Date{} = day)
      when is_binary(path) and is_binary(referrer_host) do
    if valid_path?(path) and byte_size(referrer_host) <= @max_length do
      Repo.insert_all(
        PageView,
        [%{day: day, path: path, referrer_host: referrer_host, views: 1}],
        on_conflict: [inc: [views: 1]],
        conflict_target: [:day, :path, :referrer_host]
      )

      :ok
    else
      {:error, :invalid}
    end
  end

  def record(_path, _referrer_host, _day), do: {:error, :invalid}

  defp valid_path?(path), do: String.starts_with?(path, "/") and byte_size(path) <= @max_length

  @doc """
  Totals for the last `days` days, today included (UTC):

    * `:total` - all views in the window
    * `:by_day` - `{date, views}` for every day in the window, oldest first, zeros included
    * `:top_pages` / `:top_referrers` - `{key, views}`, most viewed first, up to `limit`.
      Direct and same-site traffic appears as the referrer `""`.
  """
  def summary(days \\ 30, limit \\ 20, today \\ Date.utc_today()) when days > 0 do
    since = Date.add(today, -(days - 1))
    window = from v in PageView, where: v.day >= ^since and v.day <= ^today

    counts =
      Map.new(Repo.all(from v in window, group_by: v.day, select: {v.day, sum(v.views)}))

    by_day = for day <- Date.range(since, today), do: {day, Map.get(counts, day, 0)}

    %{
      total: by_day |> Enum.map(&elem(&1, 1)) |> Enum.sum(),
      by_day: by_day,
      top_pages: top(window, :path, limit),
      top_referrers: top(window, :referrer_host, limit)
    }
  end

  defp top(window, field, limit) do
    Repo.all(
      from v in window,
        group_by: field(v, ^field),
        select: {field(v, ^field), sum(v.views)},
        order_by: [desc: sum(v.views), asc: field(v, ^field)],
        limit: ^limit
    )
  end
end
