defmodule AlgorithmsForOptimizationWeb.MetastableFailuresRecoveryLive do
  @moduledoc """
  Metastable Failures, lesson 06: each fix described as a change to the phase plane.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Getting Out and Staying Out")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:recovery} />
        <div class="lbm-prose">
          <h1 id="page-heading">Getting Out and Staying Out</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Load shedding: moving the state back across the wall. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Backoff with jitter and retry budgets: weakening the feedback loop. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Circuit breakers and admission control: reshaping the field until the bad equilibrium disappears. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Why "add more servers" sometimes doesn't help.
               Zill 11.4's competition model has the same bistable picture. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:recovery} />
    </Layouts.app>
    """
  end
end
