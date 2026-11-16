defmodule AlgorithmsForOptimizationWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use AlgorithmsForOptimizationWeb, :html

  alias AlgorithmsForOptimization.{Collections, Topics}

  embed_templates "page_html/*"

  def pluralize(1, word), do: "1 #{word}"
  def pluralize(n, word), do: "#{n} #{word}s"

  @doc "A row in a list of topics: number, title, summary, arrow. Used on the topic and collection pages."
  attr :topic, :map, required: true

  def topic_entry(assigns) do
    ~H"""
    <.link
      id={"topic-#{@topic.id}"}
      navigate={Topics.entry_path(@topic)}
      class="lbm-topic-entry"
    >
      <span class="lbm-topic-entry-number">{@topic.number}</span>
      <div class="lbm-topic-entry-body">
        <h3 class="lbm-topic-entry-title">
          {@topic.label} <span class="lbm-topic-entry-arrow" aria-hidden="true">&rarr;</span>
        </h3>
        <p class="lbm-topic-entry-description">{@topic.description}</p>
        <div class="lbm-topic-entry-badges">
          <Layouts.type_badge kind={@topic.kind} />
          <Layouts.tag_labels tags={AlgorithmsForOptimization.Tags.for_topic(@topic)} />
        </div>
      </div>
    </.link>
    """
  end

  @doc "Heading for a landing page section, with an optional \"see all\" link."
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :link, :string, default: nil
  attr :link_label, :string, default: nil
  slot :tagline

  def section_heading(assigns) do
    ~H"""
    <div class="lbm-landing-heading">
      <div>
        <h2 id={@id} class="lbm-landing-heading-title">{@title}</h2>
        <p :if={@tagline != []} class="lbm-landing-heading-tagline">{render_slot(@tagline)}</p>
      </div>
      <.link :if={@link} navigate={@link} class="lbm-landing-heading-link">
        {@link_label} <span aria-hidden="true">&rarr;</span>
      </.link>
    </div>
    """
  end

  def collection_path(collection), do: Collections.path(collection)
end
