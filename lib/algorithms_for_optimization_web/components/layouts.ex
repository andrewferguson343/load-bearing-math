defmodule AlgorithmsForOptimizationWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use AlgorithmsForOptimizationWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="r8-header">
      <div class="r8-header-inner">
        <a href="/" class="r8-brand">
          <img src={~p"/images/logo.svg"} class="r8-brand-mark" alt="Rise8" />
          <div class="r8-brand-text">
            <span class="r8-brand-name">Optimization Algorithms</span>
            <span class="r8-brand-subtitle">by Rise8</span>
          </div>
        </a>
        <div class="r8-header-right">
          <nav class="r8-nav">
            <.link navigate={~p"/"} class="r8-nav-link">Home</.link>
            <.link navigate={~p"/overview"} class="r8-nav-link">Overview</.link>
          </nav>
          <.theme_toggle />
        </div>
      </div>
    </header>

    <main id="main-content" class="r8-main" phx-hook="KatexRender">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Renders the storybook-style lesson navigation sidebar.

  ## Examples

      <Layouts.lesson_toc active={:overview} />

  """
  attr :active, :atom,
    required: true,
    doc: "which lesson is current: :overview, :math, :optimization, etc."

  def lesson_toc(assigns) do
    ~H"""
    <aside class="r8-toc" aria-label="Lesson navigation">
      <p class="r8-toc-eyebrow">This Series</p>
      <.toc_link to={~p"/overview"} number="00" label="Overview" active={@active == :overview} />
      <.toc_link
        to={~p"/math"}
        number="01"
        label="A Mathematical Overview"
        active={@active == :math}
      />
      <.toc_link
        to={~p"/optimization"}
        number="02"
        label="An Optimal Optimization Overview"
        active={@active == :optimization}
      />
      <.toc_upcoming number="03" label="Gradient Descent" />
      <.toc_upcoming number="04" label="Newton's Method" />
      <.toc_upcoming number="05" label="Nelder-Mead / Simplex" />
      <.toc_upcoming number="06" label="Simulated Annealing" />
      <.toc_upcoming number="07" label="Genetic Algorithms" />
      <.toc_link to={~p"/appendix"} number="08" label="Appendix" active={@active == :appendix} />
      <div :if={@active == :appendix} class="r8-toc-sublist">
        <a href="#derivatives" class="r8-toc-subitem">Derivatives</a>
        <a href="#sources" class="r8-toc-subitem">Sources</a>
      </div>
    </aside>
    """
  end

  attr :to, :string, required: true
  attr :number, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  defp toc_link(assigns) do
    ~H"""
    <.link navigate={@to} class={["r8-toc-item", @active && "r8-toc-item--active"]}>
      <span class="r8-toc-number">{@number}</span> {@label}
    </.link>
    """
  end

  attr :number, :string, required: true
  attr :label, :string, required: true

  defp toc_upcoming(assigns) do
    ~H"""
    <span class="r8-toc-item r8-toc-item--upcoming">
      <span class="r8-toc-number">{@number}</span> {@label}
      <span class="r8-toc-tag">Soon</span>
    </span>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 [[data-theme-source=system]_&]:!left-0 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
