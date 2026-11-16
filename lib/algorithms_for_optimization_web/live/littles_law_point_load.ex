defmodule AlgorithmsForOptimizationWeb.LittlesLawLive do
  @moduledoc """
  Point Load: Little's Law. A single-page quickie on L = λW. Placeholder until the
  write-up lands; it only shows in dev until `:littles_law` is added to `public_topics`.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Little's Law")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:littles_law} active_lesson={:overview} />
        <div class="lbm-prose">
          <h1 id="page-heading">Little's Law</h1>
          
          <p>$$L = \lambda W$$</p>
          
          <%!-- TODO(andrew): the write-up. Suggested shape for a Point Load:
               1. The equation and what each letter is (L in the system, λ arrival rate, W time in system).
               2. One worked example: 200 req/s at 50 ms each means 10 in flight, so a pool of 8 is underwater.
               3. Why it holds for any box you can draw (no assumptions about the arrival distribution).
               4. Where it shows up: thread pools, connection pools, queue depth alerts, the leaky bucket. --%>
          <h2>More coming soon</h2>
          
          <p>
            Check back soon, or use the suggest a topic button above if there's something specific
            you'd like covered first.
          </p>
        </div>
      </div>
       <Layouts.topic_end_note active_topic={:littles_law} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
