defmodule AlgorithmsForOptimizationWeb.MarkovChainsLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Markov Chains")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="c8-lesson">
        <Layouts.lesson_toc active_topic={:markov_chains} active_lesson={:overview} />

        <div class="c8-prose">
          <h1 id="page-heading">Markov Chains</h1>

          <h2>Where do users end up in the long run?</h2>
          <p>
            Every user flow is secretly a state machine: sign up, browse, checkout, abandon, come back
            next week. Draw an arrow for every transition and attach a probability to each one, and you've
            got a Markov chain. The interesting question usually isn't "what's the next click," it's the
            long-run one: if you let this process run forever, what fraction of users end up in each state?
            That question has a clean answer, and it's the same math that ranks web pages and models
            customer churn.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
