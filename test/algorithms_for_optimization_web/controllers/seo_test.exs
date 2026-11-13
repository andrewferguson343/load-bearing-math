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

      json_ld = doc |> LazyHTML.query(~s(script[type="application/ld+json"])) |> LazyHTML.text()
      assert %{"@type" => "WebSite", "name" => "Load Bearing Math"} = Jason.decode!(json_ld)
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

  describe "crawler files" do
    test "robots.txt points at the sitemap and hides private paths", %{conn: conn} do
      body = conn |> get("/robots.txt") |> response(200)

      assert body =~ ~r{Sitemap: https?://[^/]+/sitemap\.xml}
      assert body =~ "Disallow: /topic-suggestions"
    end

    test "sitemap lists public lessons only", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")
      body = response(conn, 200)

      assert response_content_type(conn, :xml)
      assert body =~ "/cosine-similarity-math</loc>"
      assert body =~ "/topics</loc>"
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
