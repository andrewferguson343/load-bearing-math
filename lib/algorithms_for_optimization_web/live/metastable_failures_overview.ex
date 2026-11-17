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

          <%!-- TODO(andrew): possible real-world example, the 2026-11-13 FAA nationwide ground stop
               (moved here from the Little's Law Point Load):
               1. Trigger: a router reportedly retrying ~1,000 connections every 4-5 s (copper-to-fiber
                  upgrade). Cause disputed by the FAA and still under investigation; date-stamp it.
               2. Backlog: ~45k flights/day (verify) over a ~4.5 h stop is ~8k flights of displaced demand.
               3. Slow recovery: the backlog only drains at (capacity - demand), so it spilled into 11-14
                  (2,500+ more cancellations). Cancellations are the load shedding.
               Sources: Wikipedia "2026 FAA nationwide ground stop", CNN and Al Jazeera 2026-11-13,
               USDOT briefing room (Duffy update). --%>
        </div>
      </div>
      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
