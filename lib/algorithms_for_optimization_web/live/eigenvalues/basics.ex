defmodule AlgorithmsForOptimizationWeb.EigenvaluesBasicsLive do
  @moduledoc """
  Eigenvalues and Eigenvectors, lesson 01: directions a matrix only stretches, and how to find them for a 2x2.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Eigenvectors and Eigenvalues")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eigenvalues} active_lesson={:basics} />
        <div class="lbm-prose">
          <h1 id="page-heading">Eigenvectors and Eigenvalues</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. The picture: directions a matrix only stretches, never turns. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Finding them for a 2x2: the characteristic equation. Zill 8.8. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Worked example. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eigenvalues} active_lesson={:basics} />
    </Layouts.app>
    """
  end
end
