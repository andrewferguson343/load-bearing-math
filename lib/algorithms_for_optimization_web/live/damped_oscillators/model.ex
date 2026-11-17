defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsModelLive do
  @moduledoc """
  Damped Oscillators, lesson 01: the second-order equation, and why a control loop obeys it.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Spring and the Autoscaler")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:damped_oscillators} active_lesson={:model} />
        <div class="lbm-prose">
          <h1 id="page-heading">The Spring and the Autoscaler</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. The spring-mass-damper equation: mass, damping, stiffness. Zill 3.8. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Mapping the autoscaler onto it: what plays the role of each term. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Worked example with units. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:damped_oscillators} active_lesson={:model} />
    </Layouts.app>
    """
  end
end
