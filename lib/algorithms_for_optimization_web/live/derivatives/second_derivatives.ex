defmodule AlgorithmsForOptimizationWeb.DerivativesSecondDerivativesLive do
  @moduledoc """
  Foundation: Derivatives, lesson 03. Second derivatives: the rate of the rate, and the
  curvature test lesson 04 uses to tell a minimum from a maximum.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Second Derivatives")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:second_derivatives} />
        <div class="lbm-prose">
          <h1 id="page-heading">Second Derivatives</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. The rate of the rate: position, velocity, acceleration. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Curvature: concave up vs. concave down, read off the sign. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Worked example with units. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Setting up lesson 04: curvature at a flat spot tells you whether
               it's a valley or a peak. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:second_derivatives} />
    </Layouts.app>
    """
  end
end
