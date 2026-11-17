defmodule AlgorithmsForOptimizationWeb.EulersMethodSteppingLive do
  @moduledoc """
  Euler's Method, lesson 01: the algorithm: follow the slope for one small step, repeat.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Stepping Forward")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eulers_method} active_lesson={:stepping} />
        <div class="lbm-prose">
          <h1 id="page-heading">Stepping Forward</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Follow the tangent line for one step (Derivatives, the tangent line). Zill 2.6. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. The update rule, and running it by hand for a few steps. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Implementation: TODO(andrew) writes it in lib/algorithms_for_optimization/. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eulers_method} active_lesson={:stepping} />
    </Layouts.app>
    """
  end
end
