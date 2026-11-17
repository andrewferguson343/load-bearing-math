defmodule AlgorithmsForOptimizationWeb.MetastableFailuresAnatomyLive do
  @moduledoc """
  Metastable Failures, lesson 01: the story with no math: trigger vs. sustaining effect, and the three states.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Anatomy of a Metastable Failure")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:metastable_failures} active_lesson={:anatomy} />
        <div class="lbm-prose">
          <h1 id="page-heading">Anatomy of a Metastable Failure</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. The three states from the literature: stable, vulnerable, metastable. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Trigger vs. sustaining effect: what knocks it over vs. what keeps it down. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 3. Real cases: retry storms, cache stampedes, GC death spirals. --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 4. Why restarting the service often doesn't fix it.
               Sources: Bronson et al., Metastable Failures in Distributed Systems (HotOS 2021);
               Huang et al., Metastable Failures in the Wild (OSDI 2022). --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:metastable_failures} active_lesson={:anatomy} />
    </Layouts.app>
    """
  end
end
