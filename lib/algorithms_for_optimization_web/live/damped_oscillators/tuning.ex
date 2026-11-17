defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsTuningLive do
  @moduledoc """
  Damped Oscillators, lesson 04: choosing damping for a real control loop.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Tuning the Loop")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:damped_oscillators} active_lesson={:tuning} />
        <div class="lbm-prose">
          <h1 id="page-heading">Tuning the Loop</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. What "too little" and "too much" damping cost in an autoscaler. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Tuning in practice: cooldowns, stabilization windows, and what they do to the damping term. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Where this goes next: Metastable Failures, when the system has a second equilibrium. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:damped_oscillators} active_lesson={:tuning} />
    </Layouts.app>
    """
  end
end
