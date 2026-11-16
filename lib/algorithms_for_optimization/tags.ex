defmodule AlgorithmsForOptimization.Tags do
  @moduledoc """
  Subject tags (Linear Algebra, Calculus, ...). Unlike collections, where each topic has one
  home, a topic can carry several tags. Topics list tag ids in their `tags` field; each tag
  gets a page at `/tags/<slug>` listing its public topics. Order here is display order.
  """

  @tags [
    %{id: :calculus, slug: "calculus", label: "Calculus"},
    %{id: :linear_algebra, slug: "linear-algebra", label: "Linear Algebra"},
    %{
      id: :differential_equations,
      slug: "differential-equations",
      label: "Differential Equations"
    },
    %{id: :probability, slug: "probability", label: "Probability"},
    %{id: :optimization, slug: "optimization", label: "Optimization"},
    %{id: :trigonometry, slug: "trigonometry", label: "Trigonometry"},
    %{id: :graph_theory, slug: "graph-theory", label: "Graph Theory"},
    %{id: :numerical_methods, slug: "numerical-methods", label: "Numerical Methods"}
  ]

  def all, do: @tags

  def ids, do: Enum.map(@tags, & &1.id)

  def fetch!(id), do: Enum.find(@tags, &(&1.id == id)) || raise("unknown tag #{inspect(id)}")

  def get_by_slug(slug), do: Enum.find(@tags, &(&1.slug == slug))

  def path(tag), do: "/tags/" <> tag.slug

  @doc "Tag structs for a topic, in the topic's own order."
  def for_topic(%{tags: ids}), do: Enum.map(ids, &fetch!/1)
  def for_topic(_topic), do: []
end
