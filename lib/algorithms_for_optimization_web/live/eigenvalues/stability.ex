defmodule AlgorithmsForOptimizationWeb.EigenvaluesStabilityLive do
  @moduledoc """
  Eigenvalues and Eigenvectors, lesson 02: the sign and type of the eigenvalues decide whether a system settles, spirals or runs away.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Eigenvalues and Stability")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eigenvalues} active_lesson={:stability} />
        <div class="lbm-prose">
          <h1 id="page-heading">Eigenvalues and Stability</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Negative real parts settle, positive ones run away. Zill 10.2, 11.2. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Real vs. complex: nodes vs. spirals. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Where this shows up: Damped Oscillators, Metastable Failures. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eigenvalues} active_lesson={:stability} />
    </Layouts.app>
    """
  end
end
