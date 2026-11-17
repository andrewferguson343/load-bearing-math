defmodule AlgorithmsForOptimizationWeb.MetastableFailuresQueuesLive do
  @moduledoc """
  Metastable Failures, lesson 02: dq/dt = arrivals - service, and steady state.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "A Queue Is a Differential Equation")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:queues} />
        <div class="lbm-prose">
          <h1 id="page-heading">A Queue Is a Differential Equation</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. dq/dt = arrivals - service rate. Zill 1.3; the mixing-tank models in Zill 2.7 are the same equation. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Steady state: where arrivals and service balance. Tie back to Little's Law and the Leaky Bucket. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Introduce the toy retry-storm model that the rest of the series reuses. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:queues} />
    </Layouts.app>
    """
  end
end
