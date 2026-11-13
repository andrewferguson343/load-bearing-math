defmodule AlgorithmsForOptimizationWeb.SourcesLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Sources Cited")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-prose" style="max-width: 720px; margin: 2.5rem auto 0;">
        <h1 id="page-heading">Sources Cited</h1>
        <p>The books and datasets referenced across this site's lessons.</p>
        <ul>
          <li><em>Algorithms for Optimization</em> by Kochenderfer and Wheeler</li>
          <li><em>Calculus: Early Transcendentals</em> by Stewart, Clegg, and Watson</li>
          <li><em>Advanced Engineering Mathematics</em> by Zill</li>
          <li>
            GloVe: Global Vectors for Word Representation (Pennington, Socher, and Manning), Stanford NLP,
            <a href="https://nlp.stanford.edu/projects/glove/">https://nlp.stanford.edu/projects/glove/</a>
          </li>
        </ul>
      </div>
    </Layouts.app>
    """
  end
end
