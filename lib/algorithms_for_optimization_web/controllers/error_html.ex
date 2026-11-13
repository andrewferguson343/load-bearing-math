defmodule AlgorithmsForOptimizationWeb.ErrorHTML do
  @moduledoc """
  Error pages for HTML requests, invoked by the endpoint (see `render_errors` in config/config.exs).

  404 and 500 get branded pages. They are complete HTML documents that only load the
  site stylesheet: no root layout, no LiveView, no JavaScript and no database access,
  so the 500 page can still render when whatever broke is part of the normal page stack.
  The theme follows the visitor's system light/dark setting (the theme switcher is JS).

  Preview them in dev at /dev/errors/404 and /dev/errors/500 (dev shows the debug
  page for real errors).
  """
  use AlgorithmsForOptimizationWeb, :html

  def render("404.html", assigns) do
    ~H"""
    <.error_page
      code="404"
      title="This page isn't load bearing"
      message="Nothing lives at this address. The link might be old, or the page may have moved while I was rearranging things."
    />
    """
  end

  def render("500.html", assigns) do
    ~H"""
    <.error_page
      code="500"
      title="Something gave way"
      message="That one's on me, not you. The error has been logged; try again in a moment, or head back home."
    />
    """
  end

  # Any other status (e.g. 400, 403) keeps the plain-text default, e.g. "Bad Request".
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  attr :code, :string, required: true
  attr :title, :string, required: true
  attr :message, :string, required: true

  defp error_page(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="robots" content="noindex" />
        <title>{@title} · Load Bearing Math</title>
        <link rel="icon" href={~p"/images/favicon.svg"} type="image/svg+xml" />
        <link rel="stylesheet" href={~p"/assets/css/app.css"} />
      </head>
      <body>
        <header class="lbm-header">
          <div class="lbm-header-inner">
            <a href="/" class="lbm-brand">
              <div class="lbm-brand-text">
                <span class="lbm-brand-name">Load Bearing Math</span>
                <span class="lbm-brand-subtitle">by Andrew Ferguson</span>
              </div>
            </a>
          </div>
        </header>

        <main class="lbm-main">
          <section class="lbm-hero lbm-error" id={"error-#{@code}"}>
            <p class="lbm-eyebrow lbm-error-code">Error {@code}</p>
            <h1 class="lbm-hero-title">{@title}</h1>
            <p class="lbm-hero-lede">{@message}</p>
            <nav class="lbm-error-actions" aria-label="Where to next">
              <a href="/" class="lbm-error-button lbm-error-button--primary">Back to home</a>
              <a href="/topics" class="lbm-error-button">Browse topics</a>
            </nav>
          </section>
        </main>
      </body>
    </html>
    """
  end
end
