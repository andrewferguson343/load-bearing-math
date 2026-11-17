defmodule AlgorithmsForOptimizationWeb.PageViewHTML do
  @moduledoc "The private page view dashboard rendered by `PageViewController.index/2`."
  use AlgorithmsForOptimizationWeb, :html

  embed_templates "page_view_html/*"

  @doc "`value` as a percentage of `max` (0 when there's nothing to compare against)."
  def pct(_value, max) when max in [0, nil], do: 0
  def pct(value, max), do: Float.round(value / max * 100, 1)

  @doc "Largest count in a list of `{key, views}` rows."
  def max_views(rows), do: rows |> Enum.map(&elem(&1, 1)) |> Enum.max(fn -> 0 end)

  @doc "Short date for axis labels and tooltips, e.g. \"Nov 17\"."
  def short_date(%Date{} = date), do: Calendar.strftime(date, "%b %-d")

  @doc "Views with a thousands separator."
  def views(n) when is_integer(n) do
    n
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1,")
    |> String.reverse()
  end

  def referrer_label(""), do: "Direct or same site"
  def referrer_label(host), do: host

  def plural(1, word), do: word
  def plural(_n, word), do: word <> "s"
end
