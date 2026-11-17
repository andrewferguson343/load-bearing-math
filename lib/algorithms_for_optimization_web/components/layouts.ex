defmodule AlgorithmsForOptimizationWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use AlgorithmsForOptimizationWeb, :html

  alias AlgorithmsForOptimizationWeb.SEO

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
    <header
      id="site-header"
      class="lbm-header"
      phx-click-away={hide_mobile_nav()}
      phx-window-keydown={hide_mobile_nav()}
      phx-key="escape"
    >
      <div class="lbm-header-inner">
        <a href="/" class="lbm-brand">
          <div class="lbm-brand-text">
            <span class="lbm-brand-name">Load Bearing Math</span>
          </div>
        </a>

        <div class="lbm-header-right">
          <nav class="lbm-nav" aria-label="Main">
            <.link navigate={~p"/"} class="lbm-nav-link">Home</.link>
            <.link navigate={~p"/topics"} class="lbm-nav-link">Topics</.link>
            <.link navigate={~p"/services"} class="lbm-nav-link">Services</.link>
            <.link navigate={~p"/about"} class="lbm-nav-link">About</.link>
            <button type="button" class="lbm-nav-cta" phx-click={show_suggest_modal()}>
              Suggest a topic
            </button>
          </nav>

          <div class="lbm-header-theme">
            <.theme_toggle />
          </div>

          <button
            type="button"
            id="mobile-nav-toggle"
            class="lbm-menu-button"
            aria-label="Menu"
            aria-controls="mobile-nav"
            aria-expanded="false"
            phx-click={toggle_mobile_nav()}
          >
            <.icon name="hero-bars-3" class="lbm-menu-icon-open size-5" />
            <.icon name="hero-x-mark" class="lbm-menu-icon-close size-5" />
          </button>
        </div>
      </div>

      <nav id="mobile-nav" class="lbm-mobile-nav" aria-label="Main">
        <.link navigate={~p"/"} class="lbm-mobile-nav-link" phx-click={hide_mobile_nav()}>
          Home
        </.link>

        <.link navigate={~p"/topics"} class="lbm-mobile-nav-link" phx-click={hide_mobile_nav()}>
          Topics
        </.link>

        <.link navigate={~p"/services"} class="lbm-mobile-nav-link" phx-click={hide_mobile_nav()}>
          Services
        </.link>

        <.link navigate={~p"/about"} class="lbm-mobile-nav-link" phx-click={hide_mobile_nav()}>
          About
        </.link>

        <button
          type="button"
          class="lbm-nav-cta lbm-mobile-nav-cta"
          phx-click={hide_mobile_nav() |> show_suggest_modal("#mobile-nav-toggle")}
        >
          Suggest a topic
        </button>

        <div class="lbm-mobile-nav-theme">
          <span>Theme</span> <.theme_toggle />
        </div>
      </nav>
    </header>

    <div
      id="suggest-topic-modal"
      class="lbm-modal"
      role="dialog"
      aria-modal="true"
      aria-labelledby="suggest-topic-title"
      phx-click-away={hide_suggest_modal()}
      phx-window-keydown={hide_suggest_modal()}
      phx-key="escape"
      style="display: none;"
    >
      <div class="lbm-modal-backdrop" aria-hidden="true" />
      <%!-- focus_wrap keeps Tab cycling inside the dialog while it's open --%>
      <.focus_wrap id="suggest-topic-content" class="lbm-modal-content">
        <button
          type="button"
          class="lbm-modal-close"
          phx-click={hide_suggest_modal()}
          aria-label={gettext("close")}
        >
          <.icon name="hero-x-mark" class="size-5" />
        </button>

        <div class="lbm-modal-body">
          <h3 id="suggest-topic-title">Suggest a topic</h3>

          <p>Got something that belongs on this list? Drop it below.</p>

          <.form
            for={%{}}
            id="suggest-topic-form"
            action={~p"/topic-suggestions"}
            method="post"
            class="lbm-suggest-form"
          >
            <.input
              type="text"
              name="suggestion"
              id="suggest-topic-input"
              value=""
              maxlength={AlgorithmsForOptimization.TopicSuggestion.max_length()}
              aria-label="Your topic suggestion"
            />
            <%!-- Honeypot: hidden from people (and screen readers), but bots fill in every field.
                 A plain <input> on purpose; it must not look like the styled .input fields. --%>
            <div class="lbm-honeypot" aria-hidden="true">
              <label for="suggest-topic-website">Leave this field empty</label>
              <input
                type="text"
                id="suggest-topic-website"
                name={AlgorithmsForOptimizationWeb.TopicSuggestionController.honeypot_field()}
                value=""
                tabindex="-1"
                autocomplete="off"
              />
            </div>
            <.button variant="primary">Suggest it</.button>
          </.form>
        </div>
      </.focus_wrap>
    </div>

    <main id="main-content" class="lbm-main" phx-hook="KatexRender">
      {render_slot(@inner_block)}
    </main>

    <footer id="site-footer" class="lbm-site-footer">
      <nav aria-label="Footer">
        <.link navigate={~p"/about"} id="footer-about">About</.link>
        <.link navigate={~p"/services"} id="footer-services">Services</.link>
        <.link navigate={~p"/work-with-me"} id="footer-work">Work with me</.link>
        <.link navigate={~p"/tutoring"} id="footer-tutoring">Tutoring</.link>
        <.link navigate={~p"/topics"} id="footer-topics">All topics</.link>
        <.link navigate={~p"/sources"} id="footer-sources">Sources cited</.link>
        <.link navigate={~p"/privacy"} id="footer-privacy">Privacy</.link>
        <button type="button" id="footer-suggest" phx-click={show_suggest_modal()}>
          Suggest a topic
        </button>
      </nav>
    </footer>
    <.flash_group flash={@flash} />
    """
  end

  # The menu button's aria-expanded is the single source of truth: app.css shows the panel
  # with `.lbm-header:has(#mobile-nav-toggle[aria-expanded="true"])`. Driving the panel
  # with a separate JS.show/toggle or class op lets the two drift apart on fast taps.
  defp toggle_mobile_nav do
    JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "#mobile-nav-toggle")
  end

  defp hide_mobile_nav(js \\ %JS{}) do
    JS.set_attribute(js, {"aria-expanded", "false"}, to: "#mobile-nav-toggle")
  end

  # Opening remembers where focus was (`return_focus_to`, or the clicked button by default) and
  # puts the cursor in the suggestion field; closing hands focus back. From the mobile menu the
  # clicked button disappears as the menu closes, so focus returns to the menu button instead.
  # Public so page templates (e.g. the landing page footer) can open the same dialog.
  def show_suggest_modal(js \\ %JS{}, return_focus_to \\ nil) do
    js
    |> JS.push_focus(if(return_focus_to, do: [to: return_focus_to], else: []))
    |> JS.show(
      to: "#suggest-topic-modal",
      display: "flex",
      time: 150,
      transition: {"transition-opacity ease-out duration-150", "opacity-0", "opacity-100"}
    )
    |> JS.focus(to: "#suggest-topic-input")
  end

  defp hide_suggest_modal do
    JS.hide(
      to: "#suggest-topic-modal",
      time: 100,
      transition: {"transition-opacity ease-in duration-100", "opacity-100", "opacity-0"}
    )
    |> JS.pop_focus()
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
    current = AlgorithmsForOptimization.Topics.fetch!(assigns.active_topic)

    assigns =
      assigns
      |> assign(:current, current)
      |> assign(:prerequisites, AlgorithmsForOptimization.Topics.prerequisites(current))
      |> assign(:tags, AlgorithmsForOptimization.Tags.for_topic(current))

    ~H"""
    <aside class="lbm-toc" aria-label="Topic navigation">
      <p class="lbm-toc-eyebrow">{@current.label}</p>
      <.type_badge kind={@current.kind} class="lbm-toc-type" />
      <%!-- A single-page topic has nothing to navigate between, so it skips the lesson list. --%>
      <.toc_lesson
        :for={lesson <- @current.lessons}
        :if={length(@current.lessons) > 1}
        lesson={lesson}
        active_lesson={@active_lesson}
      />
      <div
        :if={@active_topic == :optimization and @active_lesson == :appendix}
        class="lbm-toc-sublist"
      >
        <a href="#derivatives" class="lbm-toc-subitem">Derivatives</a>
      </div>

      <div :if={@tags != []} class="lbm-toc-tags">
        <p class="lbm-toc-eyebrow">Subjects</p>
        <.tag_links id="topic-tags" tags={@tags} />
      </div>

      <nav
        :if={@prerequisites != []}
        id="topic-prerequisites"
        class="lbm-toc-prereqs"
        aria-label="Before you start"
      >
        <p class="lbm-toc-eyebrow">Before you start</p>

        <.link
          :for={foundation <- @prerequisites}
          navigate={AlgorithmsForOptimization.Topics.entry_path(foundation)}
          class="lbm-toc-item"
        >
          {foundation.label}
        </.link>
      </nav>
    </aside>
    """
  end

  @doc """
  Subject tags as clickable links to their `/tags/<slug>` pages. Use outside cards that are
  already links (links can't be nested); inside those, use `tag_labels/1`.
  """
  attr :tags, :list, required: true, doc: "tag maps from AlgorithmsForOptimization.Tags"
  attr :id, :string, default: nil
  attr :class, :string, default: nil

  def tag_links(assigns) do
    ~H"""
    <ul :if={@tags != []} id={@id} class={["lbm-tags", @class]}>
      <li :for={tag <- @tags}>
        <.link navigate={AlgorithmsForOptimization.Tags.path(tag)} class="lbm-tag-chip">
          {tag.label}
        </.link>
      </li>
    </ul>
    """
  end

  @doc """
  A segmented control for browsing by topic kind: All, then one segment per kind that has a
  public topic (Articles, Foundations, Point Loads). `active` is `:all` or a kind id; the
  matching segment is filled and marked `aria-current`.

      <Layouts.kind_switcher kinds={Topics.used_kinds()} active={:series} />
  """
  attr :kinds, :list,
    required: true,
    doc: "kind maps from AlgorithmsForOptimization.Topics.kinds/0"

  attr :active, :atom, required: true, doc: ":all or a kind id"
  attr :id, :string, default: "browse-by-type"

  def kind_switcher(assigns) do
    ~H"""
    <nav :if={@kinds != []} id={@id} class="lbm-kind-switcher" aria-label="Browse by type">
      <.link
        navigate={~p"/topics"}
        class={["lbm-kind-switcher-item", @active == :all && "is-active"]}
        aria-current={@active == :all && "page"}
      >
        All
      </.link>

      <.link
        :for={kind <- @kinds}
        navigate={kind.path}
        class={["lbm-kind-switcher-item", @active == kind.id && "is-active"]}
        aria-current={@active == kind.id && "page"}
      >
        {kind.label}
      </.link>
    </nav>
    """
  end

  @doc "Subject tags as plain labels, for inside cards that are themselves links."
  attr :tags, :list, required: true

  def tag_labels(assigns) do
    ~H"""
    <ul :if={@tags != []} class="lbm-tags lbm-tags--labels" aria-label="Subjects">
      <li :for={tag <- @tags}><span class="lbm-tag-chip">{tag.label}</span></li>
    </ul>
    """
  end

  @doc "Display name for a topic's kind."
  def kind_label(:foundation), do: "Foundation"
  def kind_label(:point_load), do: "Point Load"
  def kind_label(_series), do: "Article"

  @doc """
  A filled badge naming a topic's kind (Article, Foundation, Point Load). Subject tags are
  outlined, so the two read differently side by side.
  """
  attr :kind, :atom, required: true
  attr :class, :string, default: nil

  def type_badge(assigns) do
    ~H"""
    <span class={["lbm-tag lbm-type-badge", "lbm-type-badge--#{@kind}", @class]}>
      {kind_label(@kind)}
    </span>
    """
  end

  @doc """
  A pointer to engineering work, rendered below the whole lesson block (sidebar and article)
  under its own rule line so it reads as site furniture, not part of the article. Renders only on
  the topic's last published page, so multi-part topics show it once rather than on every part.

      <Layouts.topic_end_note active_topic={:leaky_bucket} active_lesson={:overview} />
  """
  attr :active_topic, :atom, required: true
  attr :active_lesson, :atom, required: true

  def topic_end_note(assigns) do
    last_key =
      assigns.active_topic
      |> AlgorithmsForOptimization.Topics.fetch!()
      |> Map.fetch!(:lessons)
      |> Enum.filter(& &1.path)
      |> List.last()
      |> Map.fetch!(:key)

    assigns = assign(assigns, :show?, last_key == assigns.active_lesson)

    ~H"""
    <aside :if={@show?} id="topic-end-note" class="lbm-topic-end-note" aria-label="Work with me">
      <p>
        Building something where this matters? <.link navigate={~p"/work-with-me"} id="end-note-work">Let's talk</.link>.
      </p>
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
    /> <.toc_upcoming :if={is_nil(@lesson.path)} number={@lesson.number} label={@lesson.label} />
    """
  end

  attr :to, :string, required: true
  attr :number, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  defp toc_link(assigns) do
    ~H"""
    <.link navigate={@to} class={["lbm-toc-item", @active && "lbm-toc-item--active"]}>
      <span class="lbm-toc-number">{@number}</span> {@label}
    </.link>
    """
  end

  attr :number, :string, required: true
  attr :label, :string, required: true

  defp toc_upcoming(assigns) do
    ~H"""
    <span class="lbm-toc-item lbm-toc-item--upcoming">
      <span class="lbm-toc-number">{@number}</span> {@label} <span class="lbm-toc-tag">Soon</span>
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
      <.flash kind={:info} flash={@flash} /> <.flash kind={:error} flash={@flash} />
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
        aria-label="Use system theme"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
        aria-label="Use light theme"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
        aria-label="Use dark theme"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  @doc """
  Search and social metadata for the `<head>`: description, canonical URL,
  Open Graph / Twitter tags, and JSON-LD structured data. See `AlgorithmsForOptimizationWeb.SEO`.
  """
  attr :page_title, :string, default: nil
  attr :page_description, :string, default: nil
  attr :canonical_path, :string, default: nil
  attr :seo_lesson, :map, default: nil, doc: "%{topic: topic, lesson: lesson} on lesson pages"
  attr :json_ld, :string, default: nil, doc: "page-specific JSON-LD (e.g. About, Services)"

  def seo_meta(assigns) do
    description = SEO.meta_description(assigns.page_description || SEO.default_description())

    json_ld =
      cond do
        assigns.seo_lesson ->
          SEO.lesson_json_ld(
            Map.merge(assigns.seo_lesson, %{
              title: assigns.page_title,
              description: description,
              path: assigns.canonical_path || assigns.seo_lesson.lesson.path
            })
          )

        assigns.json_ld ->
          assigns.json_ld

        assigns.canonical_path == "/" ->
          SEO.website_json_ld()

        true ->
          nil
      end

    assigns =
      assigns
      |> assign(:description, description)
      |> assign(:full_title, SEO.full_title(assigns.page_title))
      |> assign(:canonical_url, assigns.canonical_path && SEO.url(assigns.canonical_path))
      |> assign(:json_ld, json_ld)
      # 1200x630 share card; source is assets/og/og-image.html. ~p gives the digested path in prod.
      |> assign(:share_image_url, SEO.url(~p"/images/og-image.png"))

    ~H"""
    <meta name="description" content={@description} /> <meta name="author" content={SEO.author()} />
    <meta name="theme-color" content="#14a394" />
    <link :if={@canonical_url} rel="canonical" href={@canonical_url} />
    <meta property="og:site_name" content={SEO.site_name()} />
    <meta property="og:type" content={if(@seo_lesson, do: "article", else: "website")} />
    <meta property="og:title" content={@full_title} />
    <meta property="og:description" content={@description} />
    <meta :if={@canonical_url} property="og:url" content={@canonical_url} />
    <meta property="og:locale" content="en_US" />
    <meta property="og:image" content={@share_image_url} />
    <meta property="og:image:type" content="image/png" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
    <meta
      property="og:image:alt"
      content="Load Bearing Math: short, hands-on walkthroughs of the math behind everyday engineering"
    /> <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={@full_title} />
    <meta name="twitter:description" content={@description} />
    <meta name="twitter:image" content={@share_image_url} />
    <script :if={@json_ld} type="application/ld+json">
      <%= Phoenix.HTML.raw(@json_ld) %>
    </script>
    """
  end
end
