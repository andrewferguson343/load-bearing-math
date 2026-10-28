defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Damped Oscillators")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:damped_oscillators} active_lesson={:overview} />

        <div class="r8-prose">
          <h1 id="page-heading">Damped Oscillators</h1>

          <h2>Why autoscalers overshoot and oscillate</h2>
          <p>
            Load climbs, the autoscaler adds pods, load drops because now there's too much capacity, the
            autoscaler removes pods, load climbs again. Watch the pod count over time and it looks exactly
            like a spring bouncing after you let it go: a damped oscillator. Whether that bounce settles
            down quickly, settles down slowly, or never settles at all depends on one thing, how much
            damping is in the loop, and that's a dial you can actually turn.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
