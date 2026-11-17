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
  # The home page's <title>: the brand plus what the site is, so it reads well in search results.
  @home_title "Load Bearing Math: The math holding up the world around you"
  @default_description "Short, hands-on walkthroughs of the math behind everyday systems: search, rate limiters, autoscalers, optimization, and more."
  # Search engines show roughly this many characters of a description; longer ones get cut.
  @description_max 155

  def site_name, do: @site_name
  def home_title, do: @home_title
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
  def full_title(nil), do: @home_title
  def full_title(page_title), do: "#{page_title} · #{@site_name}"

  @doc """
  A page description trimmed to what search results show. Topic blurbs are often longer, so
  this cuts at the last word that fits and adds an ellipsis instead of letting Google truncate.
  """
  def meta_description(description) when byte_size(description) <= @description_max,
    do: description

  def meta_description(description) do
    if String.length(description) <= @description_max do
      description
    else
      cut = String.slice(description, 0, @description_max - 1)
      trimmed = cut |> String.replace(~r/\s+\S*$/u, "") |> String.trim_trailing(",;:.")
      trimmed <> "…"
    end
  end

  @doc "JSON-LD for the About page: the person behind the site."
  def person_json_ld do
    %{
      "@context" => "https://schema.org",
      "@type" => "Person",
      "name" => @author,
      "url" => url("/about"),
      "description" =>
        "Software engineer with a systems focus who writes Load Bearing Math and teaches math and computer science.",
      "knowsAbout" => [
        "Mathematics",
        "Computer science",
        "Linear algebra",
        "Calculus",
        "Differential equations",
        "Probability",
        "Optimization",
        "Queueing theory",
        "Systems engineering"
      ]
    }
    |> Jason.encode!(escape: :html_safe)
  end

  @doc "JSON-LD for the Services page: tutoring as a service, with each offering and its price."
  def tutoring_service_json_ld(offerings) do
    %{
      "@context" => "https://schema.org",
      "@type" => "Service",
      "name" => "Math and computer science tutoring",
      "serviceType" => "Tutoring",
      "url" => url("/tutoring"),
      "provider" => %{"@type" => "Person", "name" => @author, "url" => url("/about")},
      "hasOfferCatalog" => %{
        "@type" => "OfferCatalog",
        "name" => "Tutoring offerings",
        "itemListElement" => Enum.map(offerings, &offer_json/1)
      }
    }
    |> Jason.encode!(escape: :html_safe)
  end

  # "$60" becomes a numeric price; "Custom" has none, so it's listed without one.
  defp offer_json(offering) do
    base = %{
      "@type" => "Offer",
      "name" => offering.name,
      "description" => offering.description
    }

    case Regex.run(~r/^\$(\d+(?:\.\d+)?)$/, offering.price) do
      [_, amount] -> Map.merge(base, %{"price" => amount, "priceCurrency" => "USD"})
      nil -> base
    end
  end

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
      "publisher" => %{"@type" => "Organization", "name" => @site_name}
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
