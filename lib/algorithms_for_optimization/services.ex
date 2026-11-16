defmodule AlgorithmsForOptimization.Services do
  @moduledoc """
  The tutoring offerings shown as cards on /services, in display order. Add, remove or
  reorder entries here; the inquiry form's "What are you interested in?" list follows.
  `best_for` is the short "Best for" line under each card's name.

  `id` is stored with each inquiry, so rename an offering's `name` freely but keep its `id`.
  """

  @offerings [
    %{
      id: :tier_one,
      name: "Tutoring",
      best_for: "Any student, any level",
      price: "$60",
      price_note: "per hour",
      description:
        "One-on-one help with the math or computer science you're working on right now: homework, a course that's gotten away from you, or an exam coming up.",
      includes: [
        "Sessions built around your own coursework",
        "Bring homework, notes or practice exams",
        "Math: algebra and trigonometry through differential equations",
        "Computer science: programming, data structures, algorithms, and the math behind them"
      ],
      highlighted: false
    },
    %{
      id: :tier_two,
      name: "Get Ahead",
      best_for: "K–12 students",
      price: "$220",
      price_note: "per month, four 1-hour sessions",
      description:
        "Supplemental teaching that goes beyond the classroom: get ahead of the syllabus, or go deeper than it does.",
      includes: [
        "A plan built around where you want to be",
        "Preview topics before they come up in class",
        "Real-world applications, like the topics on this site"
      ],
      # Visually emphasized as the suggested option.
      highlighted: true
    },
    # DRAFT for review. Quietly aimed at homeschooling families (parents who want the math
    # taught for them) without naming them: a whole course, structured and reported on.
    %{
      id: :tier_three,
      name: "Full Course",
      best_for: "Students who need a structured curriculum, or are ready for calculus and beyond",
      price: "Custom",
      price_note: "priced based on the curriculum",
      description:
        "A complete course, taught from start to finish and built from the ground up, for learning a subject on its own rather than alongside a class.",
      includes: [
        "A full lesson plan, mapped out from the first session to the last",
        "Teaching, practice problems, and checkpoints along the way",
        "Regular progress updates for the family"
      ],
      highlighted: false
    }
  ]

  def offerings, do: @offerings

  @doc "Options for the inquiry form's select: `{name, id}` pairs."
  def select_options, do: Enum.map(@offerings, &{&1.name, to_string(&1.id)})
end
