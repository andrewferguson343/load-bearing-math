defmodule AlgorithmsForOptimizationWeb.EulersMethodLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Euler's Method")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="c8-lesson">
        <Layouts.lesson_toc active_topic={:eulers_method} active_lesson={:overview} />

        <div class="c8-prose">
          <h1 id="page-heading">Euler's Method</h1>

          <h2>Why game physics explode at large time steps</h2>
          <p>
            A game can't solve the real differential equations of motion exactly, every frame, in real
            time, so it cheats: take the current velocity, multiply by a small time step, add that to
            position, then do the same for velocity with the current forces. That's Euler's method, the
            simplest way to turn a continuous equation into something you can compute one step at a time.
            It works well when the time step is small. Make the step too large, drop a frame, or hit a
            stiff collision, and the error in each step compounds into the next one until a character is
            clipping through the floor or spinning off into space.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
