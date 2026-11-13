defmodule AlgorithmsForOptimizationWeb.MetastableFailuresLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Metastable Failures")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:overview} />

        <div class="lbm-prose">
          <h1 id="page-heading">Metastable Failures</h1>

          <h2>Why a system can stay down after the trigger is gone</h2>
          <p>
            A traffic spike hits, retries pile up, latency climbs, more retries fire, and the system settles
            into a new normal: slow and failing, even after the original spike has long since passed. That's
            a metastable failure. The system didn't just get knocked over, it found a second stable state and
            stayed there. A phase plane makes this visible: plot the right two variables against each other
            and you can see both equilibria, the healthy one and the failing one, along with the boundary you
            have to cross to get back.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
