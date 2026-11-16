defmodule AlgorithmsForOptimization.Collections do
  @moduledoc """
  Registry of the groups topics are filed under (see `collection` on each topic in
  `AlgorithmsForOptimization.Topics`). Each one gets a card on the landing page and a
  page at `/collections/<slug>`.

  `:point_loads` holds single-page quickies (`kind: :point_load`) and `:foundations` holds
  single-page primers (`kind: :foundation`, listed in suggested reading order). Both get their
  own strip on the landing page instead of a card in the collections grid.
  """

  @collections [
    %{
      id: :foundations,
      slug: "foundations",
      name: "Foundations",
      description:
        "Short primers on the basics the other topics build on. Read them in order, or jump to the one you need.",
      # Sorts after the themed collections on the Topics page, just above Point Loads; the
      # landing page places its strip explicitly and ignores this.
      order: 98
    },
    %{
      id: :search_and_ranking,
      slug: "search-and-ranking",
      name: "Search & Ranking",
      description:
        "How computers decide what's similar, what matters most, and where things end up.",
      order: 1
    },
    %{
      id: :reliability_and_control,
      slug: "reliability-and-control",
      name: "Reliability & Control",
      description: "The math that keeps systems steady under load, and explains how they fail.",
      order: 2
    },
    %{
      id: :simulation_and_optimization,
      slug: "simulation-and-optimization",
      name: "Simulation & Optimization",
      description: "How machines step through time and search for the best answer.",
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

  @doc "Collections shown as cards in the landing page grid. Foundations and Point Loads get their own strips."
  def grid, do: Enum.reject(all(), &(&1.id in [:foundations, :point_loads]))

  def fetch!(id),
    do: Enum.find(@collections, &(&1.id == id)) || raise("unknown collection #{inspect(id)}")

  def get_by_slug(slug), do: Enum.find(@collections, &(&1.slug == slug))

  def path(collection), do: "/collections/" <> collection.slug
end
