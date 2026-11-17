defmodule AlgorithmsForOptimizationWeb.EigenvaluesLive do
  @moduledoc """
  Eigenvalues and Eigenvectors, lesson 00: the overview: why eigenvalues show up in stability, ranking and dynamics.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Eigenvalues and Eigenvectors")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:eigenvalues} active_lesson={:overview} />
        <div class="lbm-prose">
          <h1 id="page-heading">Eigenvalues and Eigenvectors</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write.
               Keep, rename or drop sections freely. --%>

          <%!-- TODO(andrew) 1. Why a reader should care: stability (Damped Oscillators, Metastable Failures),
               ranking (PageRank), long-run behavior (Markov Chains). --%>
          <h2>TODO</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Where we're headed: one item per lesson in this primer. --%>
          <h2>TODO</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:eigenvalues} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
