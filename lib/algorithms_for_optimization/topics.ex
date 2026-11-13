defmodule AlgorithmsForOptimization.Topics do
  @moduledoc """
  Registry of the site's topic "series" (Optimization, Cosine Similarity, ...).
  Keep a topic off `:public_topics` in config while you work on it, then add
  its id to the list and redeploy when you're ready to share it.
  """

  @dev_routes? Application.compile_env(:algorithms_for_optimization, :dev_routes, false)
  @public_topics Application.compile_env(:algorithms_for_optimization, :public_topics, [])

  @topics [
    %{
      id: :cosine_similarity,
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
      number: "09",
      label: "Mathematics Appendix",
      description:
        "The shared toolbox behind every series on this site: derivatives, gradients, linear algebra, eigenvectors. One place to look things up instead of re-deriving them in the middle of a lesson on something else.",
      lessons: [
        %{key: :overview, number: "00", label: "Overview", path: "/mathematics-appendix"}
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
end
