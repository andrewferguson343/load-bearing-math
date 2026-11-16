defmodule AlgorithmsForOptimizationWeb.TagsTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.{Tags, Topics}

  defp doc(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()

  describe "registry" do
    test "every topic's tags exist in the Tags registry" do
      known = MapSet.new(Tags.ids())

      for topic <- Topics.all(), tag <- topic.tags do
        assert tag in known, "#{topic.id} has unknown tag #{inspect(tag)}"
      end
    end

    test "tag slugs are unique" do
      slugs = Enum.map(Tags.all(), & &1.slug)
      assert slugs == Enum.uniq(slugs)
    end

    test "used_tags/0 only counts public topics" do
      for tag <- Topics.used_tags() do
        assert Topics.with_tag(tag.id) != []
      end
    end
  end

  describe "GET /tags/:slug" do
    test "lists the public topics with that tag, never gated ones", %{conn: conn} do
      page = doc(conn, ~p"/tags/linear-algebra")

      assert has?(page, "#tag-page-linear-algebra")
      assert has?(page, "#topic-cosine_similarity")
      refute has?(page, "#topic-pagerank")
      refute has?(page, "#topic-markov_chains")
    end

    test "404s for an unknown tag", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/tags/not-a-subject") end
    end
  end

  test "the Topics page has a Browse by subject row of tag links", %{conn: conn} do
    page = doc(conn, ~p"/topics")

    assert has?(page, ~s(#browse-by-subject a[href="/tags/linear-algebra"]))
    assert has?(page, "#topic-cosine_similarity .lbm-tag-chip")
  end

  test "a topic's sidebar links to its subjects", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/cosine-similarity")

    assert has_element?(view, ~s(#topic-tags a[href="/tags/linear-algebra"]))
    assert has_element?(view, ~s(#topic-tags a[href="/tags/trigonometry"]))
  end

  describe "type badges" do
    test "name each kind" do
      alias AlgorithmsForOptimizationWeb.Layouts

      assert Layouts.kind_label(:series) == "Article"
      assert Layouts.kind_label(:foundation) == "Foundation"
      assert Layouts.kind_label(:point_load) == "Point Load"
    end

    test "show on topic cards and in the topic sidebar", %{conn: conn} do
      assert has?(doc(conn, ~p"/topics"), "#topic-cosine_similarity .lbm-type-badge--series")

      {:ok, view, _html} = live(conn, ~p"/cosine-similarity")
      assert has_element?(view, ".lbm-toc .lbm-type-badge--series", "Article")
    end
  end

  test "the sitemap lists tags used by public topics only", %{conn: conn} do
    body = conn |> get(~p"/sitemap.xml") |> response(200)

    assert body =~ "/tags/linear-algebra</loc>"
    refute body =~ "/tags/graph-theory</loc>"
  end
end
