defmodule AlgorithmsForOptimizationWeb.EulersMethodBetterSteppersLive do
  @moduledoc """
  Euler's Method, lesson 04: midpoint, Runge-Kutta, and semi-implicit Euler, briefly.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Better Steppers")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eulers_method} active_lesson={:better_steppers} />
        <div class="lbm-prose">
          <h1 id="page-heading">Better Steppers</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Midpoint and RK4: sample the slope more than once per step. Zill 6.2. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Semi-implicit (symplectic) Euler: what game engines actually use. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Where this goes next: the simulation behind Metastable Failures. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eulers_method} active_lesson={:better_steppers} />
    </Layouts.app>
    """
  end
end
