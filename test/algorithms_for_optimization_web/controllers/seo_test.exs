defmodule AlgorithmsForOptimizationWeb.SEOTest do
  use AlgorithmsForOptimizationWeb.ConnCase

  import Phoenix.LiveViewTest

  defp head(html), do: LazyHTML.from_document(html)

  defp attr(doc, selector, name) do
    doc |> LazyHTML.query(selector) |> LazyHTML.attribute(name) |> List.first()
  end

  describe "page metadata" do
    test "home page has description, canonical, Open Graph and WebSite JSON-LD", %{conn: conn} do
      doc = conn |> get(~p"/") |> html_response(200) |> head()

      assert attr(doc, ~s(meta[name="description"]), "content") ==
               AlgorithmsForOptimizationWeb.SEO.default_description()

      assert attr(doc, ~s(link[rel="canonical"]), "href") =~ ~r{^https?://[^/]+/$}
      assert attr(doc, ~s(meta[property="og:title"]), "content") =~ "Load Bearing Math"
      assert attr(doc, ~s(link[rel="icon"][type="image/svg+xml"]), "href") =~ "favicon"

      # Share card: absolute URL (crawlers don't resolve relative ones) + large Twitter/X card.
      assert attr(doc, ~s(meta[property="og:image"]), "content") =~
               ~r{^https?://[^/]+/images/og-image.*\.png$}

      assert attr(doc, ~s(meta[name="twitter:card"]), "content") == "summary_large_image"

      json_ld = doc |> LazyHTML.query(~s(script[type="application/ld+json"])) |> LazyHTML.text()
      assert %{"@type" => "WebSite", "name" => "Load Bearing Math"} = Jason.decode!(json_ld)
    end

    test "titles use the site name, never a personal byline", %{conn: conn} do
      home = conn |> get(~p"/") |> html_response(200)
      tutoring = conn |> get(~p"/tutoring") |> html_response(200)

      assert home |> head() |> LazyHTML.query("title") |> LazyHTML.text() |> String.trim() ==
               AlgorithmsForOptimizationWeb.SEO.home_title()

      assert tutoring |> head() |> LazyHTML.query("title") |> LazyHTML.text() =~
               "Math and Computer Science Tutoring · Load Bearing Math"

      refute home =~ "by Andrew Ferguson"
    end

    test "lesson page has its own description and LearningResource JSON-LD", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/cosine-similarity-math")
      doc = head(html)

      assert attr(doc, ~s(meta[name="description"]), "content") =~ "dot product"
      assert attr(doc, ~s(link[rel="canonical"]), "href") =~ ~r{/cosine-similarity-math$}
      assert attr(doc, ~s(meta[property="og:type"]), "content") == "article"

      json_ld = doc |> LazyHTML.query(~s(script[type="application/ld+json"])) |> LazyHTML.text()

      assert %{
               "@type" => "LearningResource",
               "name" => "Cosine Similarity: An Introduction to the Math",
               "author" => %{"name" => "Andrew Ferguson"}
             } = Jason.decode!(json_ld)
    end
  end

  describe "descriptions and structured data" do
    alias AlgorithmsForOptimizationWeb.SEO

    test "long descriptions are trimmed at a word boundary for search results" do
      long = String.duplicate("word ", 60)
      trimmed = SEO.meta_description(long)

      assert String.length(trimmed) <= 155
      assert String.ends_with?(trimmed, "word…")
      assert SEO.meta_description("Short and sweet.") == "Short and sweet."
    end

    test "every page's description fits in search results", %{conn: conn} do
      for path <- [
            ~p"/",
            ~p"/about",
            ~p"/services",
            ~p"/tutoring",
            ~p"/sources",
            ~p"/leaky-bucket"
          ] do
        html = conn |> get(path) |> html_response(200)
        description = html |> head() |> attr(~s(meta[name="description"]), "content")

        assert String.length(description) <= 155, "#{path}: #{String.length(description)} chars"
      end
    end

    test "About has Person JSON-LD", %{conn: conn} do
      json = conn |> get(~p"/about") |> html_response(200) |> head() |> json_ld()
      assert %{"@type" => "Person", "name" => "Andrew Ferguson"} = json
    end

    test "Tutoring has Service JSON-LD with priced offers", %{conn: conn} do
      json = conn |> get(~p"/tutoring") |> html_response(200) |> head() |> json_ld()

      assert %{"@type" => "Service", "hasOfferCatalog" => %{"itemListElement" => offers}} = json
      assert %{"name" => "Tutoring", "price" => "60", "priceCurrency" => "USD"} = hd(offers)
      assert Enum.any?(offers, &(&1["name"] == "Full Course" and not Map.has_key?(&1, "price")))
    end
  end

  defp json_ld(doc) do
    doc
    |> LazyHTML.query(~s(script[type="application/ld+json"]))
    |> LazyHTML.text()
    |> Jason.decode!()
  end

  describe "crawler files" do
    test "robots.txt points at the sitemap and hides private paths", %{conn: conn} do
      body = conn |> get("/robots.txt") |> response(200)

      assert body =~ ~r{Sitemap: https?://[^/]+/sitemap\.xml}
      assert body =~ "Disallow: /topic-suggestions"
      assert body =~ "Disallow: /tutoring-inquiries"
    end

    test "sitemap lists public lessons only", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")
      body = response(conn, 200)

      assert response_content_type(conn, :xml)
      assert body =~ "/cosine-similarity-math</loc>"
      assert body =~ "/topics</loc>"
      assert body =~ "/about</loc>"
      assert body =~ "/services</loc>"
      assert body =~ "/tutoring</loc>"
      assert body =~ "/privacy</loc>"
      assert body =~ "/work-with-me</loc>"
      assert body =~ "/collections/search-and-ranking</loc>"
      refute body =~ "/collections/simulation-and-optimization</loc>"
      refute body =~ "/pagerank</loc>"
      refute body =~ "/topic-suggestions"
    end
  end

  describe "/topic-suggestions" do
    test "requires basic auth", %{conn: conn} do
      assert conn |> get(~p"/topic-suggestions") |> response(401)
    end

    test "is readable with the configured credentials", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "secret"))
        |> get(~p"/topic-suggestions")

      assert response(conn, 200)
    end
  end
end
