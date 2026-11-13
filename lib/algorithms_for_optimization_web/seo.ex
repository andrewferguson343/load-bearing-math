defmodule AlgorithmsForOptimizationWeb.SEO do
  @moduledoc """
  Search/social metadata for every page: description, canonical URL,
  Open Graph tags and JSON-LD structured data, rendered by the root layout.

  Controllers get `:canonical_path` from the `put_canonical_path/2` plug in the
  browser pipeline. LiveViews get it from the `on_mount/4` hook, which every
  LiveView picks up through `use AlgorithmsForOptimizationWeb, :live_view`.
  Topic pages get their description and structured data from `TopicAuth`.
  """

  import Phoenix.Component, only: [assign: 3]

  @site_name "Load Bearing Math"
  @author "Andrew Ferguson"
  @default_description "Short, hands-on walkthroughs connecting the math you haven't touched since school to the systems you work with every day: search, rate limiters, autoscalers, optimization, and more."

  def site_name, do: @site_name
  def author, do: @author
  def default_description, do: @default_description

  @doc "Plug: records the request path so the root layout can emit a canonical URL."
  def put_canonical_path(conn, _opts) do
    Plug.Conn.assign(conn, :canonical_path, conn.request_path)
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     Phoenix.LiveView.attach_hook(socket, :seo_canonical_path, :handle_params, fn _params,
                                                                                  uri,
                                                                                  socket ->
       {:cont, assign(socket, :canonical_path, URI.parse(uri).path)}
     end)}
  end

  @doc "Absolute URL for a path on this site, based on the endpoint's configured host."
  def url(path), do: AlgorithmsForOptimizationWeb.Endpoint.url() <> path

  @doc "Full document title, matching what `live_title` renders."
  def full_title(nil), do: "#{@site_name} · #{@author}"
  def full_title(page_title), do: "#{page_title} · #{@author}"

  @doc "JSON-LD for a lesson page, as an HTML-safe JSON string."
  def lesson_json_ld(%{
        topic: topic,
        lesson: lesson,
        title: title,
        description: description,
        path: path
      }) do
    %{
      "@context" => "https://schema.org",
      "@type" => "LearningResource",
      "name" => title || lesson.label,
      "headline" => title || lesson.label,
      "description" => description,
      "url" => url(path),
      "inLanguage" => "en",
      "learningResourceType" => "Lesson",
      "teaches" => topic.label,
      "isPartOf" => %{"@type" => "Course", "name" => topic.label},
      "author" => %{"@type" => "Person", "name" => @author},
      "publisher" => %{"@type" => "Person", "name" => @author}
    }
    |> Jason.encode!(escape: :html_safe)
  end

  @doc "JSON-LD for the site itself, used on the home page."
  def website_json_ld do
    %{
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => @site_name,
      "url" => url("/"),
      "description" => @default_description,
      "author" => %{"@type" => "Person", "name" => @author}
    }
    |> Jason.encode!(escape: :html_safe)
  end
end
