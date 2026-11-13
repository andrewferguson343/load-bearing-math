defmodule AlgorithmsForOptimization.Collections do
  @moduledoc """
  Registry of the groups topics are filed under (see `collection` on each topic in
  `AlgorithmsForOptimization.Topics`). Each one gets a card on the landing page and a
  page at `/collections/<slug>`.

  `:point_loads` is the home of single-page quickies (`kind: :point_load`). It has its own
  strip on the landing page instead of a card in the collections grid.
  """

  @collections [
    %{
      id: :systems,
      slug: "systems",
      name: "[PLACEHOLDER: Collection One name]",
      description: "[PLACEHOLDER: Collection One one-line description]",
      order: 1
    },
    %{
      id: :linear_algebra,
      slug: "linear-algebra",
      name: "[PLACEHOLDER: Collection Two name]",
      description: "[PLACEHOLDER: Collection Two one-line description]",
      order: 2
    },
    %{
      id: :differential_equations,
      slug: "differential-equations",
      name: "[PLACEHOLDER: Collection Three name]",
      description: "[PLACEHOLDER: Collection Three one-line description]",
      order: 3
    },
    %{
      id: :point_loads,
      slug: "point-loads",
      name: "Point Loads",
      description: "One equation carrying a lot of weight.",
      order: 99
    }
  ]

  def all, do: Enum.sort_by(@collections, & &1.order)

  @doc "Collections shown as cards in the landing page grid (everything but Point Loads)."
  def grid, do: Enum.reject(all(), &(&1.id == :point_loads))

  def fetch!(id),
    do: Enum.find(@collections, &(&1.id == id)) || raise("unknown collection #{inspect(id)}")

  def get_by_slug(slug), do: Enum.find(@collections, &(&1.slug == slug))

  def path(collection), do: "/collections/" <> collection.slug
end
