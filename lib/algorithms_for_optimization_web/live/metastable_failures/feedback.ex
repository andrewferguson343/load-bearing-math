defmodule AlgorithmsForOptimizationWeb.MetastableFailuresFeedbackLive do
  @moduledoc """
  Metastable Failures, lesson 03: retries make arrivals depend on q, so dq/dt = f(q) can have more than one equilibrium.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Feedback Loop")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:feedback} />
        <div class="lbm-prose">
          <h1 id="page-heading">The Feedback Loop</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Timeouts -> retries -> more arrivals -> longer queue -> more timeouts. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Plot f(q): more than one zero means more than one equilibrium. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Stability by the sign of f around each zero (Derivatives, "reading the sign").
               Zill 2.1: autonomous first-order DEs, critical points, attractors and repellers. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Bistability and hysteresis: the way down isn't the way back up. Strogatz ch. 2-3. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:feedback} />
    </Layouts.app>
    """
  end
end
