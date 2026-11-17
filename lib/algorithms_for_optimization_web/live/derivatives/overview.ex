defmodule AlgorithmsForOptimizationWeb.DerivativesLive do
  @moduledoc """
  Foundation: Derivatives, lesson 00. The overview that introduces the primer and
  points at the lessons that follow, the same shape as the Cosine Similarity overview.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Derivatives")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:overview} />
        <div class="lbm-prose">
          <h1 id="page-heading">Derivatives</h1>

          <p>
            Ah, derivatives. Two notebook pages of chain rule, and the mistake was on line 1. Memories. Here's what all that work actually meant.
          </p>

          <p>
            It's hard to open a mathematics, physics, or advanced computer science textbook without finding at least a chapter on derivatives.
            In school they probably felt like numbers on paper and a pile of convoluted techniques you'd never use again.
            But they hold up a lot of what we interact with day to day. From finding the best solution to a problem to modeling the flow of user traffic,
            derivatives are doing the heavy lifting.
          </p>

          <p>
            This primer covers what derivatives actually are, a couple of techniques for finding them, and some worked examples.
            If you're here as a prerequisite for another page, the core ideas will be clearly marked so you can skip the heavier stuff.
          </p>

          <h2 id="where-were-headed">Here's what's next</h2>
          <ul>
            <li>What derivatives actually are</li>
            <li>Basic examples</li>
            <li>The chain rule</li>
            <li>Second derivatives</li>
            <li>Finding an optimal value</li>
          </ul>
        </div>
      </div>
      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
