defmodule AlgorithmsForOptimizationWeb.DerivativesChainRuleLive do
  @moduledoc """
  Foundation: Derivatives, lesson 02. The chain rule: derivatives of functions inside
  functions, and the payoff the overview's hook promises.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Chain Rule")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:chain_rule} />
        <div class="lbm-prose">
          <h1 id="page-heading">The Chain Rule</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Why it exists: functions inside functions, and why the basic
               rules from lesson 01 stop working on them. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. The rule itself, as rates multiplying: if y changes with u and
               u changes with x, how fast does y change with x? --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Worked example(s). The two-notebook-pages payoff from the hook. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Where it shows up: backpropagation is the chain rule applied
               layer by layer. One or two sentences, link once Optimization is public. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:chain_rule} />
    </Layouts.app>
    """
  end
end
