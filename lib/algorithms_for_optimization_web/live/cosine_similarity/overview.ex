defmodule AlgorithmsForOptimizationWeb.CosineSimilarityLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Cosine Similarity")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:cosine_similarity} active_lesson={:overview} />

        <div class="r8-prose">
          <h1 id="page-heading">Cosine Similarity</h1>

          <h2>How could this possibly have anything to do with our jobs?</h2>
          <p>
            We are all using AI every day to make ourselves more impactful at work. Even before this we had to
            put some vague questions into Google to hopefully find a solution to a very specific problem
            on Stack Overflow where some poor dev was probably getting yelled at by some other poor dev with nothing better to do.

            But how does claude actually know what you're looking for? How can it tell the meaning behind the words? I'm going to
            give a brief overview of how the mathematics behind all of this works, with a very small example (it gets out of hand pretty fast)
            to hopefully share some cool facts with the rest of everybody.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
