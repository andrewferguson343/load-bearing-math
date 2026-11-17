defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsPhasePlaneLive do
  @moduledoc """
  Damped Oscillators, lesson 03: a second-order equation as two first-order ones; eigenvalues pick spiral vs. node.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Phase Plane")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:damped_oscillators} active_lesson={:phase_plane} />
        <div class="lbm-prose">
          <h1 id="page-heading">The Phase Plane</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Rewriting as a 2x2 system (position, velocity). Zill 10.1-10.2. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Eigenvalues decide the picture: spirals, nodes, centers. Zill 11.2. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. This is the linear phase plane Metastable Failures builds on. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:damped_oscillators} active_lesson={:phase_plane} />
    </Layouts.app>
    """
  end
end
