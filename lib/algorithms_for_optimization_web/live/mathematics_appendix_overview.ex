defmodule AlgorithmsForOptimizationWeb.MathematicsAppendixLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Mathematics Appendix")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:mathematics_appendix} active_lesson={:overview} />

        <div class="r8-prose">
          <h1 id="page-heading">Mathematics Appendix</h1>

          <h2>The shared toolbox</h2>
          <p>
            Every series on this site leans on the same handful of mathematical ideas: derivatives,
            gradients, vectors, eigenvectors, the occasional differential equation. Rather than
            re-deriving them every time they come up, this page is the one place to look them up.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
