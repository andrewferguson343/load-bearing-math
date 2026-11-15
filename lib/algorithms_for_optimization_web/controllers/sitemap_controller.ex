defmodule AlgorithmsForOptimizationWeb.SitemapController do
  @moduledoc """
  Serves `robots.txt` and `sitemap.xml`. Both are generated per request so they
  use the endpoint's configured host and only list topics that are public in
  this build (see `AlgorithmsForOptimization.Topics.visible/0`).
  """
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.{Collections, Topics}
  alias AlgorithmsForOptimizationWeb.SEO

  @static_pages ["/", "/about", "/topics", "/sources"]

  def robots(conn, _params) do
    body = """
    User-agent: *
    Allow: /
    Disallow: /topic-suggestions
    Disallow: /dev/

    Sitemap: #{SEO.url("/sitemap.xml")}
    """

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end

  def sitemap(conn, _params) do
    urls =
      Enum.map(paths(), fn path ->
        "  <url><loc>#{xml_escape(SEO.url(path))}</loc></url>"
      end)

    body =
      Enum.join(
        [
          ~s(<?xml version="1.0" encoding="UTF-8"?>),
          ~s(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">)
          | urls
        ] ++ ["</urlset>", ""],
        "\n"
      )

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, body)
  end

  @doc false
  def paths do
    lesson_paths =
      for topic <- Topics.visible(),
          lesson <- topic.lessons,
          lesson.path,
          do: lesson.path

    # Only collections with at least one public topic, so empty "coming soon" pages stay out.
    collection_paths =
      for collection <- Collections.all(),
          Topics.in_collection(collection.id) != [],
          do: Collections.path(collection)

    Enum.uniq(@static_pages ++ collection_paths ++ lesson_paths)
  end

  defp xml_escape(string) do
    string
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end
end
