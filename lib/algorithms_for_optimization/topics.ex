defmodule AlgorithmsForOptimization.Topics do
  @moduledoc """
  Registry of the site's topic "series" (Optimization, Cosine Similarity, ...).
  Keep a topic off `:public_topics` in config while you work on it, then add
  its id to the list and redeploy when you're ready to share it.

  Landing page fields on each topic:

    * `collection` - id from `AlgorithmsForOptimization.Collections` (or `nil`)
    * `kind` - `:series` for multi-part topics, `:point_load` for single-page quickies,
      `:foundation` for single-page primers on the basics (collection `:foundations`)
    * `published_on` - `Date` it went public; orders "Recently posted" and drives the "New"
      badge. Not displayed (`nil` sorts last).
    * `summary` - one line for cards; `card_summary/1` falls back to `description`
    * `featured` - the landing page's featured topic (first visible one wins)
    * `tags` - subject tag ids from `AlgorithmsForOptimization.Tags` (a topic can have several)
    * `prerequisites` - ids of foundation topics to read first; shown as "Before you start"
      in the topic's sidebar. Only public ones appear.
  """

  @dev_routes? Application.compile_env(:algorithms_for_optimization, :dev_routes, false)
  @public_topics Application.compile_env(:algorithms_for_optimization, :public_topics, [])

  @topics [
    %{
      id: :cosine_similarity,
      tags: [:linear_algebra, :trigonometry],
      collection: :search_and_ranking,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: ~D[2026-10-28],
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: true,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "01",
      label: "Cosine Similarity",
      description:
        "The angle between two vectors turns out to be the whole trick: it's how search engines, recommendation systems, and every embedding model decide what counts as similar.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/cosine-similarity"},
        %{
          key: :math,
          number: "01",
          label: "An Introduction to the Math",
          path: "/cosine-similarity-math",
          description:
            "The math behind cosine similarity from the ground up: what a vector is, how to plot one in 2D and 3D, and how the dot product turns two vectors into a single number."
        },
        %{
          key: :implementation,
          number: "02",
          label: "A Simple Cosine Similarity Example",
          path: "/cosine-similarity-implementation",
          description:
            "Cosine similarity worked through by hand: turn a few video games into trait vectors, then use the angle between them to see which games are most alike."
        },
        %{
          key: :realistic_example,
          number: "03",
          label: "A More Realistic Example",
          path: "/cosine-similarity-realistic-example",
          description:
            "Scale cosine similarity up to 50-dimensional word vectors: pick a word and see its nearest neighbors, the same idea that powers semantic search and embeddings."
        }
      ]
    },
    %{
      id: :leaky_bucket,
      tags: [:differential_equations],
      collection: :reliability_and_control,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: ~D[2026-11-03],
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "02",
      label: "The Leaky Bucket",
      description:
        "A bucket with a hole in the bottom turns out to be a surprisingly good model for traffic control. One differential equation, and it's the algorithm standing between you and that 429 the next time you hammer an API.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/leaky-bucket"}
      ]
    },
    %{
      id: :markov_chains,
      tags: [:probability, :linear_algebra],
      collection: :search_and_ranking,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "03",
      label: "Markov Chains",
      description:
        "A user flow is just a state machine with probabilities bolted on. Markov chains are how you figure out where everyone actually ends up in the long run, no matter how tangled the flow looks on the whiteboard.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/markov-chains"}
      ]
    },
    %{
      id: :pagerank,
      tags: [:linear_algebra, :graph_theory, :probability],
      collection: :search_and_ranking,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "04",
      label: "PageRank",
      description:
        "The algorithm that built Google is, underneath, just an eigenvector. Find the one that belongs to an eigenvalue of 1, and you've found the most important node in any graph, web pages included.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/pagerank"}
      ]
    },
    %{
      id: :metastable_failures,
      tags: [:differential_equations],
      collection: :reliability_and_control,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "05",
      label: "Metastable Failures",
      description:
        "Some outages don't need the original trigger anymore to keep going: the system found a second, self-sustaining equilibrium and settled in. Phase planes make that visible: plot the right two variables and you can see the stable state you want, the failure state you're stuck in, and the wall between them you have to clear to get back.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/metastable-failures"}
      ]
    },
    %{
      id: :damped_oscillators,
      tags: [:differential_equations],
      collection: :reliability_and_control,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "06",
      label: "Damped Oscillators",
      description:
        "An autoscaler that adds pods, overshoots, scales back down, overshoots again, and settles into a slow wobble is running the exact same equation as a spring with too little friction. Get the damping term wrong and a control loop doesn't converge, it oscillates, sometimes forever.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/damped-oscillators"}
      ]
    },
    %{
      id: :eulers_method,
      tags: [:differential_equations, :numerical_methods],
      collection: :simulation_and_optimization,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "07",
      label: "Euler's Method",
      description:
        "Every game engine updates physics the same crude way: take the current velocity, nudge position forward by a tiny time step, repeat. That's Euler's method, and it's an approximation, not the real answer. Make the time step too large and the error compounds until your character is phasing through the floor or flying off into the void.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/eulers-method"}
      ]
    },
    %{
      id: :optimization,
      tags: [:optimization, :calculus],
      collection: :simulation_and_optimization,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [:derivatives],
      number: "08",
      label: "Optimization Algorithms",
      description:
        "Every system you'd call \"AI\" is, underneath, a search for the inputs that minimize error or maximize reward. Bracketing, gradient descent, simulated annealing: this is how machines find the best answer when guessing isn't good enough.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/overview"},
        %{key: :math, number: "01", label: "A Mathematical Overview", path: "/math"},
        %{
          key: :optimization,
          number: "02",
          label: "An Optimal Optimization Overview",
          path: "/optimization"
        },
        %{key: :gradient_descent, number: "03", label: "Gradient Descent", path: nil},
        %{key: :newtons_method, number: "04", label: "Newton's Method", path: nil},
        %{key: :nelder_mead, number: "05", label: "Nelder-Mead / Simplex", path: nil},
        %{key: :simulated_annealing, number: "06", label: "Simulated Annealing", path: nil},
        %{key: :genetic_algorithms, number: "07", label: "Genetic Algorithms", path: nil},
        %{key: :appendix, number: "08", label: "Appendix", path: "/appendix"}
      ]
    },
    %{
      id: :mathematics_appendix,
      tags: [:calculus, :linear_algebra],
      collection: nil,
      kind: :series,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary: nil,
      featured: false,
      # Foundation ids to read first, shown as "Before you start" (see Topics.prerequisites/1)
      prerequisites: [],
      number: "09",
      label: "Mathematics Appendix",
      description:
        "The shared toolbox behind every topic on this site: derivatives, gradients, linear algebra, eigenvectors. One place to look things up instead of re-deriving them in the middle of a topic on something else.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/mathematics-appendix"}
      ]
    },
    # Foundations: single-page primers. Registry order is the suggested reading order.
    %{
      id: :derivatives,
      tags: [:calculus],
      collection: :foundations,
      kind: :foundation,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary:
        "What a derivative measures, how to read it off a graph, and why a slope of zero is where every optimizer wants to end up.",
      featured: false,
      prerequisites: [],
      number: "10",
      label: "Derivatives and Slope",
      description:
        "A derivative is the slope of a curve at a single point: how fast something is changing right now. It's the one idea under gradient descent, control loops, and every \"rate of\" number you've ever put on a dashboard.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/derivatives"}
      ]
    },
    # Point Loads: single-page quickies, one equation each.
    %{
      id: :littles_law,
      tags: [:probability],
      collection: :point_loads,
      kind: :point_load,
      # Set to the date it goes public: orders "Recently posted" and drives the "New" badge (not shown).
      published_on: nil,
      # Optional one-line card summary; cards fall back to the description
      summary:
        "L = λW. Three letters that tell you how many requests are in flight, and why your worker pool is already too small.",
      featured: false,
      prerequisites: [],
      number: "11",
      label: "Little's Law",
      description:
        "The number of things in a system equals how fast they arrive times how long they stay. L = λW holds for any queue you can draw a box around, from a web server's request pool to the line at the DMV, and it's the fastest sanity check in capacity planning.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/littles-law"}
      ]
    }
  ]

  def all, do: @topics

  def fetch!(id), do: Enum.find(@topics, &(&1.id == id)) || raise("unknown topic #{inspect(id)}")

  @doc "Topics visible for this build: public ones, plus everything when dev_routes is on."
  def visible, do: Enum.filter(@topics, &public?(&1.id))

  @doc "Path to a topic's first lesson, used as its entry point link."
  def entry_path(topic), do: topic.lessons |> List.first() |> Map.fetch!(:path)

  def public?(topic_id) do
    @dev_routes? or topic_id in @public_topics
  end

  @doc "The visible topic flagged `featured`, or `nil`."
  def featured, do: Enum.find(visible(), & &1.featured)

  @doc "The newest `limit` visible topics by `published_on`; undated ones come last."
  def recent(limit \\ 5) do
    {dated, undated} = Enum.split_with(visible(), & &1.published_on)

    dated
    |> Enum.sort_by(& &1.published_on, {:desc, Date})
    |> Kernel.++(undated)
    |> Enum.take(limit)
  end

  @doc "Visible topics of one kind (`:series` or `:point_load`), newest first."
  def by_kind(kind), do: recent(length(@topics)) |> Enum.filter(&(&1.kind == kind))

  @doc """
  The visible foundations a topic lists as prerequisites, in the order listed.
  Unknown or not-yet-public ids are skipped, so a topic can name a foundation before it ships.
  """
  def prerequisites(%{prerequisites: ids}) do
    Enum.flat_map(ids, fn id ->
      case Enum.find(@topics, &(&1.id == id)) do
        %{kind: :foundation} = topic -> if public?(topic.id), do: [topic], else: []
        _ -> []
      end
    end)
  end

  def prerequisites(_topic), do: []

  @doc "Visible topics carrying a tag, in registry order."
  def with_tag(tag_id), do: Enum.filter(visible(), &(tag_id in Map.get(&1, :tags, [])))

  @doc "Tags that at least one visible topic uses, in the Tags registry's display order."
  def used_tags do
    used = visible() |> Enum.flat_map(&Map.get(&1, :tags, [])) |> MapSet.new()
    Enum.filter(AlgorithmsForOptimization.Tags.all(), &(&1.id in used))
  end

  @doc "Visible topics in a collection, in registry order."
  def in_collection(collection_id), do: Enum.filter(visible(), &(&1.collection == collection_id))

  @doc "How many topics in a collection are still unpublished (a count only, never names)."
  def upcoming_count(collection_id) do
    Enum.count(@topics, &(&1.collection == collection_id and not public?(&1.id)))
  end

  @doc "Published within the last `days` days of `today`."
  def new?(topic, today \\ Date.utc_today(), days \\ 14)
  def new?(%{published_on: nil}, _today, _days), do: false

  def new?(%{published_on: date}, today, days) do
    Date.diff(today, date) in 0..days
  end

  @doc "One-line text for cards: `summary` if set, otherwise the full `description`."
  def card_summary(topic), do: topic[:summary] || topic.description

  @doc "Lessons with a page, i.e. not the \"Soon\" placeholders."
  def published_lesson_count(topic), do: Enum.count(topic.lessons, & &1.path)
end
