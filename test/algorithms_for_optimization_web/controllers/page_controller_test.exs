defmodule AlgorithmsForOptimizationWeb.PageControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase

  alias AlgorithmsForOptimization.{Collections, Topics}

  defp doc(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()

  describe "landing page" do
    test "renders every section", %{conn: conn} do
      page = doc(conn, ~p"/")

      for id <- ~w(landing-hero landing-featured landing-recent landing-collections
                   landing-point-loads landing-footer) do
        assert has?(page, "##{id}"), "missing ##{id}"
      end
    end

    test "features the featured topic and links the hero button to it", %{conn: conn} do
      page = doc(conn, ~p"/")
      featured = Topics.featured()

      assert featured.id == :cosine_similarity
      assert has?(page, "#featured-cosine_similarity")
      assert has?(page, ~s(#hero-start[href="#{Topics.entry_path(featured)}"]))
      assert has?(page, ~s(#hero-browse[href="/topics"]))
    end

    test "lists visible topics as recently posted", %{conn: conn} do
      page = doc(conn, ~p"/")

      for topic <- Topics.visible() do
        assert has?(page, "#recent-#{topic.id}")
      end
    end

    test "shows a card per collection, linking to its page", %{conn: conn} do
      page = doc(conn, ~p"/")

      for collection <- Collections.grid() do
        assert has?(
                 page,
                 ~s(#collection-#{collection.slug}[href="/collections/#{collection.slug}"])
               )
      end

      refute has?(page, "#collection-point-loads")
    end

    test "never shows gated topics", %{conn: conn} do
      html = conn |> get(~p"/") |> html_response(200)

      gated = Enum.reject(Topics.all(), &Topics.public?(&1.id))
      assert gated != [], "expected at least one gated topic in the test config"

      for topic <- gated do
        refute html =~ "recent-#{topic.id}"
        refute html =~ Topics.entry_path(topic)
      end
    end

    test "footer links to the about page", %{conn: conn} do
      assert has?(doc(conn, ~p"/"), ~s(#footer-about[href="/about"]))
    end
  end

  test "GET /about keeps the intro letter", %{conn: conn} do
    page = doc(conn, ~p"/about")

    assert has?(page, "#about-page")
    assert page |> LazyHTML.query("h1") |> LazyHTML.text() =~ "Behind It All"
  end

  describe "topics page" do
    test "groups visible topics by collection", %{conn: conn} do
      page = doc(conn, ~p"/topics")

      assert has?(page, "#topics-linear-algebra #topic-cosine_similarity")
      assert has?(page, "#topics-differential-equations #topic-leaky_bucket")
      refute has?(page, "#topic-pagerank")
    end
  end

  describe "collection pages" do
    test "list the collection's visible topics only", %{conn: conn} do
      page = doc(conn, ~p"/collections/linear-algebra")

      assert has?(page, "#collection-page-linear-algebra")
      assert has?(page, "#topic-cosine_similarity")
      refute has?(page, "#topic-pagerank")
      refute has?(page, "#topic-markov_chains")
    end

    test "show an empty state when nothing is public yet", %{conn: conn} do
      assert has?(doc(conn, ~p"/collections/systems"), "#collection-empty")
    end

    test "404 for an unknown slug", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/collections/not-a-collection") end
    end
  end
end
