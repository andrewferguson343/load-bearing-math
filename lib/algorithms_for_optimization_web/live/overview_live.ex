defmodule AlgorithmsForOptimizationWeb.OverviewLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Overview")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active={:overview} />

        <div class="r8-prose">
          <h1 id="page-heading">Overview</h1>

          <h2>What is optimization?</h2>
          <p>
            AI has quietly taken over huge parts of our daily lives. We take it for granted every time we log
            on to work or pull up an agent on our phone. I'm certainly guilty of giving Claude far too vague a prompt
            and expecting a great result, or burning tokens on something I could've done myself at the push of a
            button. Underneath all of that convenience are algorithms attempting to make the best decision possible
            within their constraints. In this brief little side project, I'll walk through some of the common
            optimization algorithms currently making the world go round, and inflating the size of the bubble.
          </p>

          <h2>Who is this for?</h2>
          <p>
            I intend for this to be as technical as the reader wants it to be. For those who are more technically
            inclined, the math behind each algorithm will be tucked behind a "Check My Math" button, but the
            goal is for this to be approachable to anyone curious about optimization and what's really going on
            underneath it all. I'm also hoping to include the source code for each algorithm, for the SWEs in the room.
            That'll be tucked behind a "Show Me the Code" button too, so things stay brief and don't overwhelm anyone who's not interested.
          </p>

          <h2>What will be covered?</h2>
          <p>
            The first thing I'll need to cover is some foundational math. I'll do my best to explain it with a
            non-technical TL;DR/BLUF before diving into the deeper stuff. If you don't care about the math,
            the TL;DR should be enough to follow along. With that in mind, here's what I'll be covering:
          </p>
          <ul>
            <li>A mathematical overview</li>
            <li>An Optimal Optimization Overview</li>
            <li>Gradient Descent</li>
            <li>Newton's Method</li>
            <li>Nelder-Mead / Simplex</li>
            <li>Simulated Annealing</li>
            <li>Genetic Algorithms</li>
          </ul>
          <p>
            There's plenty more I could cover. If this is well received, I may put together a part two, or
            tackle a different mathematical subject. For now, though, I think this is a natural progression.
          </p>

          <div class="r8-lesson-footer">
            <div class="r8-lesson-footer-next">
              <span class="r8-lesson-footer-label">Up Next</span>
              <span class="r8-lesson-footer-title">A Mathematical Overview (coming soon)</span>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
