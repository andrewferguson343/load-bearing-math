defmodule AlgorithmsForOptimization.Services do
  @moduledoc """
  The tutoring offerings shown as cards on /services, in display order. Add, remove or
  reorder entries here; the inquiry form's "What are you interested in?" list follows.

  `id` is stored with each inquiry, so rename an offering's `name` freely but keep its `id`.
  """

  @offerings [
    %{
      id: :tier_one,
      name: "[PLACEHOLDER: offering one name]",
      price: "[PLACEHOLDER: price]",
      price_note: "[PLACEHOLDER: per session / per month]",
      description: "[PLACEHOLDER: one or two sentences on who this is for]",
      includes: [
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]"
      ],
      highlighted: false
    },
    %{
      id: :tier_two,
      name: "[PLACEHOLDER: offering two name]",
      price: "[PLACEHOLDER: price]",
      price_note: "[PLACEHOLDER: per session / per month]",
      description: "[PLACEHOLDER: one or two sentences on who this is for]",
      includes: [
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]"
      ],
      # Visually emphasized as the suggested option.
      highlighted: true
    },
    %{
      id: :tier_three,
      name: "[PLACEHOLDER: offering three name]",
      price: "[PLACEHOLDER: price]",
      price_note: "[PLACEHOLDER: per session / per month]",
      description: "[PLACEHOLDER: one or two sentences on who this is for]",
      includes: [
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]",
        "[PLACEHOLDER: what's included]"
      ],
      highlighted: false
    }
  ]

  def offerings, do: @offerings

  @doc "Options for the inquiry form's select: `{name, id}` pairs."
  def select_options, do: Enum.map(@offerings, &{&1.name, to_string(&1.id)})
end
