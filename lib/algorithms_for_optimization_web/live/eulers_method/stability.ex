defmodule AlgorithmsForOptimizationWeb.EulersMethodStabilityLive do
  @moduledoc """
  Euler's Method, lesson 03: numerical instability: the game-physics explosion.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "When It Blows Up")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eulers_method} active_lesson={:stability} />
        <div class="lbm-prose">
          <h1 id="page-heading">When It Blows Up</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Stiff problems and step-size limits. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. The exploding spring: Euler on an oscillator gains energy every step. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Why a dropped frame can launch a character into space. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eulers_method} active_lesson={:stability} />
    </Layouts.app>
    """
  end
end
