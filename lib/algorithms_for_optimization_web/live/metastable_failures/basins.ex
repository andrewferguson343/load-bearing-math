defmodule AlgorithmsForOptimizationWeb.MetastableFailuresBasinsLive do
  @moduledoc """
  Metastable Failures, lesson 05: basins of attraction, and why running near capacity makes you vulnerable.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "How Close to the Edge")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:basins} />
        <div class="lbm-prose">
          <h1 id="page-heading">How Close to the Edge</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Basin of attraction: how big a trigger it takes to cross the wall. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Efficiency vs. resilience as geometry: the healthy basin shrinks as utilization climbs.
               Zill 11.3-11.5 covers this only partially; Strogatz ch. 5-6 is better. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:basins} />
    </Layouts.app>
    """
  end
end
