defmodule AlgorithmsForOptimizationWeb.DerivativesOptimalValueLive do
  @moduledoc """
  Foundation: Derivatives, lesson 04. Finding an optimal value: set the derivative to zero,
  check the curvature, and see where that stops working (the hand-off to the Optimization
  series).
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Finding an Optimal Value")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:optimal_value} />
        <div class="lbm-prose">
          <h1 id="page-heading">Finding an Optimal Value</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Why a slope of zero is where the best answer hides. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Min, max or neither: the second-derivative test from lesson 03. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Local vs. global: why the first valley you find may not be the
               deepest one. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Worked engineering example. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 5. Where this breaks: when you can't solve f'(x) = 0 by hand, and
               why that's the whole reason gradient descent exists. Link to Optimization once
               it's public. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:optimal_value} />
    </Layouts.app>
    """
  end
end
