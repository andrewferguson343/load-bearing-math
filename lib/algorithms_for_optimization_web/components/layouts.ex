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
    <style>
      .c8-nav-cta {
        font-family: var(--font-heading);
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        background: var(--color-primary);
        color: var(--color-primary-content);
        border: none;
        border-radius: 999px;
        padding: 0.5rem 1rem;
        cursor: pointer;
        transition: filter 0.2s ease, transform 0.2s ease;
      }
      .c8-nav-cta:hover { filter: brightness(1.1); transform: translateY(-1px); }
      .c8-suggest-form { display: flex; gap: 0.5rem; align-items: flex-start; flex-wrap: wrap; margin-top: 1rem; }
      .c8-suggest-form .fieldset { margin-bottom: 0; flex: 1 1 260px; }
    </style>

    <header class="c8-header">
      <div class="c8-header-inner">
        <a href="/" class="c8-brand">
          <div class="c8-brand-text">
            <span class="c8-brand-name">Calcul8</span>
            <span class="c8-brand-subtitle">by Andrew Ferguson</span>
          </div>
        </a>
        <div class="c8-header-right">
          <nav class="c8-nav">
            <.link navigate={~p"/"} class="c8-nav-link">Home</.link>
            <.link navigate={~p"/topics"} class="c8-nav-link">Topics</.link>
            <button type="button" class="c8-nav-cta" phx-click={show_suggest_modal()}>
              Suggest a Topic
            </button>
          </nav>
          <.theme_toggle />
        </div>
      </div>
    </header>

    <div
      id="suggest-topic-modal"
      class="c8-modal"
      role="dialog"
      aria-modal="true"
      phx-click-away={hide_suggest_modal()}
      phx-window-keydown={hide_suggest_modal()}
      phx-key="escape"
      style="display: none;"
    >
      <div class="c8-modal-backdrop" aria-hidden="true" />
      <div class="c8-modal-content">
        <button
          type="button"
          class="c8-modal-close"
          phx-click={hide_suggest_modal()}
          aria-label={gettext("close")}
        >
          <.icon name="hero-x-mark" class="size-5" />
        </button>
        <div class="c8-modal-body">
          <h3>Suggest a Topic</h3>
          <p>Got something that belongs on this list? Drop it below.</p>
          <.form for={%{}} action={~p"/topic-suggestions"} method="post" class="c8-suggest-form">
            <.input type="text" name="suggestion" value="" />
            <.button variant="primary">Suggest it</.button>
          </.form>
        </div>
      </div>
    </div>

    <main id="main-content" class="c8-main" phx-hook="KatexRender">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  defp show_suggest_modal do
    JS.show(
      to: "#suggest-topic-modal",
      display: "flex",
      time: 150,
      transition: {"transition-opacity ease-out duration-150", "opacity-0", "opacity-100"}
    )
  end

  defp hide_suggest_modal do
    JS.hide(
      to: "#suggest-topic-modal",
      time: 100,
      transition: {"transition-opacity ease-in duration-100", "opacity-100", "opacity-0"}
    )
  end

  @doc """
  Renders the storybook-style lesson navigation sidebar.

  ## Examples

      <Layouts.lesson_toc active={:overview} />

  """
  attr :active_topic, :atom,
    required: true,
    doc: "which topic series is current: :optimization, :cosine_similarity, etc."

  attr :active_lesson, :atom,
    required: true,
    doc: "which lesson within the active topic is current: :overview, :math, etc."

  def lesson_toc(assigns) do
    assigns = assign(assigns, :current, AlgorithmsForOptimization.Topics.fetch!(assigns.active_topic))

    ~H"""
    <aside class="c8-toc" aria-label="Lesson navigation">
      <p class="c8-toc-eyebrow">{@current.label}</p>

      <.toc_lesson :for={lesson <- @current.lessons} lesson={lesson} active_lesson={@active_lesson} />

      <div :if={@active_topic == :optimization and @active_lesson == :appendix} class="c8-toc-sublist">
        <a href="#derivatives" class="c8-toc-subitem">Derivatives</a>
      </div>
    </aside>
    """
  end

  attr :lesson, :map, required: true
  attr :active_lesson, :atom, required: true

  defp toc_lesson(assigns) do
    ~H"""
    <.toc_link
      :if={@lesson.path}
      to={@lesson.path}
      number={@lesson.number}
      label={@lesson.label}
      active={@lesson.key == @active_lesson}
    />
    <.toc_upcoming :if={is_nil(@lesson.path)} number={@lesson.number} label={@lesson.label} />
    """
  end

  attr :to, :string, required: true
  attr :number, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  defp toc_link(assigns) do
    ~H"""
    <.link navigate={@to} class={["c8-toc-item", @active && "c8-toc-item--active"]}>
      <span class="c8-toc-number">{@number}</span> {@label}
    </.link>
    """
  end

  attr :number, :string, required: true
  attr :label, :string, required: true

  defp toc_upcoming(assigns) do
    ~H"""
    <span class="c8-toc-item c8-toc-item--upcoming">
      <span class="c8-toc-number">{@number}</span> {@label}
      <span class="c8-toc-tag">Soon</span>
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
