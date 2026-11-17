defmodule AlgorithmsForOptimizationWeb.EulersMethodErrorLive do
  @moduledoc """
  Euler's Method, lesson 02: local vs. global error, and what the step size buys you.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Where the Error Comes From")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eulers_method} active_lesson={:error} />
        <div class="lbm-prose">
          <h1 id="page-heading">Where the Error Comes From</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Local error per step vs. global error over the run. Zill 6.1. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Halve the step, halve the error: first-order accuracy. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Interactive chart: exact solution vs. Euler at several step sizes. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eulers_method} active_lesson={:error} />
    </Layouts.app>
    """
  end
end
