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

          <h2>Why this, and why now?</h2>
          <p>
            Pulling this thread from Zill's <em>Advanced Engineering Mathematics</em>, since it's the piece
            of vector math that quietly underpins how most modern AI systems decide what's "similar." Every
            time a search tool, recommendation engine, or embedding model compares two pieces of text, it's
            almost always asking one question: how close is the angle between these two vectors? That
            question is cosine similarity, and it shows up everywhere once you know to look for it.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
