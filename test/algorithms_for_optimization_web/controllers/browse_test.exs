defmodule AlgorithmsForOptimizationWeb.BrowseTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  alias AlgorithmsForOptimization.Topics

  defp doc(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()

  defp numbers(doc, scope) do
    doc
    |> LazyHTML.query("#{scope} .lbm-topic-entry-number")
    |> Enum.map(&(&1 |> LazyHTML.text() |> String.trim()))
  end

  describe "list numbering" do
    # The Leaky Bucket is registry number "02" but the only public topic in its collection,
    # so it must show as 01 wherever it's listed: numbers count within the list, not the registry.
    test "each collection on the Topics page counts from 01", %{conn: conn} do
      page = doc(conn, ~p"/topics")

      assert numbers(page, "#topics-reliability-and-control") == ["01"]
      assert numbers(page, "#topics-search-and-ranking") == ["01"]
    end

    test "a collection page counts from 01", %{conn: conn} do
      page = doc(conn, ~p"/collections/reliability-and-control")
      assert numbers(page, "#collection-topics") == ["01"]
    end

    test "a tag page counts from 01", %{conn: conn} do
      page = doc(conn, ~p"/tags/differential-equations")
      assert numbers(page, "#tag-topics") == ["01"]
    end
  end

  describe "browse by type" do
    test "the Topics page has a type switcher with All active and a segment per used kind",
         %{conn: conn} do
      page = doc(conn, ~p"/topics")

      assert has?(page, ~s(#browse-by-type a[href="/topics"][aria-current="page"]))
      assert has?(page, ~s|#browse-by-type a[href="/articles"]:not([aria-current])|)
      # No foundation or Point Load is public in the test build, so those segments stay out.
      refute has?(page, ~s(#browse-by-type a[href="/collections/foundations"]))
      refute has?(page, ~s(#browse-by-type a[href="/collections/point-loads"]))
    end

    test "the Articles page shows the same switcher with Articles active", %{conn: conn} do
      page = doc(conn, ~p"/articles")

      assert has?(page, ~s(#browse-by-type a[href="/articles"][aria-current="page"]))
      assert has?(page, ~s|#browse-by-type a[href="/topics"]:not([aria-current])|)
    end

    test "ordinary collection pages don't show the switcher", %{conn: conn} do
      refute has?(doc(conn, ~p"/collections/search-and-ranking"), "#browse-by-type")
    end

    test "used_kinds/0 only reports kinds that a public topic has" do
      for kind <- Topics.used_kinds() do
        assert Enum.any?(Topics.visible(), &(&1.kind == kind.id))
      end
    end

    test "kinds/0 names every kind a topic can have" do
      kind_ids = Enum.map(Topics.kinds(), & &1.id)
      for topic <- Topics.all(), do: assert(topic.kind in kind_ids, "#{topic.id}")
    end
  end

  describe "GET /articles" do
    test "lists public articles grouped by collection, never other kinds or gated topics",
         %{conn: conn} do
      page = doc(conn, ~p"/articles")

      assert has?(page, "#articles-page")
      assert has?(page, "#articles-search-and-ranking #topic-cosine_similarity")
      assert has?(page, "#articles-reliability-and-control #topic-leaky_bucket")
      refute has?(page, "#topic-pagerank")

      for topic <- Topics.all(), topic.kind != :series do
        refute has?(page, "#topic-#{topic.id}"), "#{topic.id} is not an article"
      end
    end

    test "offers the subject row and a way back to all topics", %{conn: conn} do
      page = doc(conn, ~p"/articles")

      assert has?(page, ~s(#browse-by-subject a[href="/tags/linear-algebra"]))
      assert has?(page, ~s(a[href="/topics"]))
    end

    test "is in the sitemap", %{conn: conn} do
      assert conn |> get(~p"/sitemap.xml") |> response(200) =~ "/articles</loc>"
    end
  end
end
