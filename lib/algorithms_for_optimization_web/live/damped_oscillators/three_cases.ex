defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsThreeCasesLive do
  @moduledoc """
  Damped Oscillators, lesson 02: underdamped, critically damped, overdamped, from the characteristic equation.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Three Kinds of Damping")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:damped_oscillators} active_lesson={:three_cases} />
        <div class="lbm-prose">
          <h1 id="page-heading">Three Kinds of Damping</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. The characteristic equation and its roots. Zill 3.3, 3.8. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Underdamped, critically damped, overdamped: what each looks like over time. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Interactive chart: one damping slider, three behaviors. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:damped_oscillators} active_lesson={:three_cases} />
    </Layouts.app>
    """
  end
end
