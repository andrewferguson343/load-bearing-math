defmodule AlgorithmsForOptimizationWeb.PageControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase

  alias AlgorithmsForOptimization.{Collections, Topics}

  defp doc(conn, path), do: conn |> get(path) |> html_response(200) |> LazyHTML.from_document()
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()

  describe "landing page" do
    test "renders every section", %{conn: conn} do
      page = doc(conn, ~p"/")

      for id <- ~w(landing-hero landing-featured landing-recent landing-collections site-footer) do
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

    test "empty Foundations and Point Loads sections are hidden, not shown as placeholders",
         %{conn: conn} do
      page = doc(conn, ~p"/")

      # No foundation or Point Load is public in the test build yet.
      refute has?(page, "#landing-foundations")
      refute has?(page, "#landing-point-loads")
      # The dev-only reminders only render when dev_routes is on (it's off in tests).
      refute has?(page, "#dev-note-foundations")
      refute has?(page, "#collection-foundations")
    end

    test "the home page has no placeholder text left", %{conn: conn} do
      refute conn |> get(~p"/") |> html_response(200) =~ "PLACEHOLDER"
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

    test "every page has the site footer with its links", %{conn: conn} do
      for path <- [~p"/", ~p"/topics", ~p"/about", ~p"/services", ~p"/work-with-me", ~p"/privacy"] do
        page = doc(conn, path)

        for id <- ~w(footer-about footer-services footer-work footer-topics footer-sources
                     footer-privacy footer-suggest) do
          assert has?(page, "#site-footer ##{id}"), "#{path} is missing ##{id}"
        end
      end
    end

    test "header and mobile menu link to the about page", %{conn: conn} do
      page = doc(conn, ~p"/")

      assert has?(page, ~s(.lbm-nav a[href="/about"]))
      assert has?(page, ~s(#mobile-nav a[href="/about"]))
    end
  end

  test "GET /about has every section and points to topics first", %{conn: conn} do
    page = doc(conn, ~p"/about")

    for id <- ~w(about-page about-mission about-who about-teaching about-site about-personal) do
      assert has?(page, "##{id}"), "missing ##{id}"
    end

    assert has?(page, ~s(#about-topics[href="/topics"]))
    assert has?(page, ~s(#about-services[href="/services"]))
  end

  describe "privacy page" do
    test "explains what's collected and gives a deletion contact", %{conn: conn} do
      page = doc(conn, ~p"/privacy")
      email = Application.fetch_env!(:algorithms_for_optimization, :contact_email)

      for id <- ~w(privacy-collect privacy-cookies privacy-dont privacy-keep privacy-hosting) do
        assert has?(page, "##{id}"), "missing ##{id}"
      end

      assert has?(page, ~s(#privacy-contact[href="mailto:#{email}"]))
    end

    test "is linked from the landing footer and the inquiry form", %{conn: conn} do
      assert has?(doc(conn, ~p"/"), ~s(#footer-privacy[href="/privacy"]))
      assert has?(doc(conn, ~p"/services"), ~s(#inquiry-privacy-link[href="/privacy"]))
    end
  end

  describe "topics page" do
    test "groups visible topics by collection", %{conn: conn} do
      page = doc(conn, ~p"/topics")

      assert has?(page, "#topics-search-and-ranking #topic-cosine_similarity")
      assert has?(page, "#topics-reliability-and-control #topic-leaky_bucket")
      refute has?(page, "#topic-pagerank")
    end
  end

  describe "collection pages" do
    test "list the collection's visible topics only", %{conn: conn} do
      page = doc(conn, ~p"/collections/search-and-ranking")

      assert has?(page, "#collection-page-search-and-ranking")
      assert has?(page, "#topic-cosine_similarity")
      refute has?(page, "#topic-pagerank")
      refute has?(page, "#topic-markov_chains")
    end

    test "show an empty state when nothing is public yet", %{conn: conn} do
      assert has?(doc(conn, ~p"/collections/simulation-and-optimization"), "#collection-empty")
    end

    test "404 for an unknown slug", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/collections/not-a-collection") end
    end
  end
end
