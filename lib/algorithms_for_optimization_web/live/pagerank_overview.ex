defmodule AlgorithmsForOptimizationWeb.PageRankLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "PageRank")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:pagerank} active_lesson={:overview} />

        <div class="lbm-prose">
          <h1 id="page-heading">PageRank</h1>

          <h2>Finding the most important node in any graph</h2>
          <p>
            A link from one page to another is a vote, but not all votes count the same: a link from an
            important page should carry more weight than a link from an obscure one. Write that rule down
            as a matrix and ask for the vector that doesn't change when you apply it, and you've just asked
            for an eigenvector. The eigenvector belonging to an eigenvalue of 1 is the answer: it's the
            steady-state importance of every node in the graph, and it's the same math whether the graph
            is the web, a social network, or anything else you can draw as nodes and edges.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
