defmodule AlgorithmsForOptimizationWeb.OptimizationLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Overview")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active={:optimization} />

        <div class="r8-prose">
          <h1 id="page-heading">An Optimal Optimization Overview</h1>
          optimization
        </div>
      </div>
    </Layouts.app>
    """
  end
end
