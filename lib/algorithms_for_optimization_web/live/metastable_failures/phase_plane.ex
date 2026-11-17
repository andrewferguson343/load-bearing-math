defmodule AlgorithmsForOptimizationWeb.MetastableFailuresPhasePlaneLive do
  @moduledoc """
  Metastable Failures, lesson 04: two variables, nullclines, equilibria, and the separatrix (the wall).
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Phase Plane")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:phase_plane} />
        <div class="lbm-prose">
          <h1 id="page-heading">The Phase Plane</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Two variables: queue length and retry rate (or offered load vs. goodput). --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Nullclines, equilibria, the vector field. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Classifying equilibria with the Jacobian's eigenvalues. Zill 8.8, 10.2, 11.1-11.3. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. The saddle and its stable manifold: the separatrix is the wall. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 5. Centerpiece: interactive chart. Reader sets the spike size and watches the system
               recover or get stuck (simulated with Euler's method). --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:phase_plane} />
    </Layouts.app>
    """
  end
end
