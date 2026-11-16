defmodule AlgorithmsForOptimizationWeb.SourcesLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Sources cited")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <article id="sources-page" class="lbm-about">
        <header class="lbm-hero lbm-about-hero">
          <p class="lbm-eyebrow">Sources</p>
          <h1 id="page-heading" class="lbm-hero-title">Sources cited</h1>
          <p class="lbm-hero-lede">The books and datasets referenced across this site's topics.</p>
        </header>

        <section class="lbm-about-section">
          <ul class="lbm-work-areas">
            <li><em>Algorithms for Optimization</em> by Kochenderfer and Wheeler</li>
            <li><em>Calculus: Early Transcendentals</em> by Stewart, Clegg, and Watson</li>
            <li><em>Advanced Engineering Mathematics</em> by Zill</li>
            <li>
              GloVe: Global Vectors for Word Representation (Pennington, Socher, and Manning), Stanford NLP,
              <a href="https://nlp.stanford.edu/projects/glove/">nlp.stanford.edu/projects/glove</a>
            </li>
          </ul>
        </section>
      </article>
    </Layouts.app>
    """
  end
end
