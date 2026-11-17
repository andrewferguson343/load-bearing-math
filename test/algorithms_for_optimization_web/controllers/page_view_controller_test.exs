defmodule AlgorithmsForOptimizationWeb.PageViewControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  import Ecto.Query

  alias AlgorithmsForOptimization.{PageView, Repo}

  @browser_ua "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Gecko/20100101 Firefox/140.0"

  # The rate limiter is shared across tests, so each test gets its own IP.
  setup %{conn: conn} do
    n = System.unique_integer([:positive])
    ip = {10, rem(div(n, 65_536), 256), rem(div(n, 256), 256), rem(n, 256)}

    conn =
      conn
      |> Map.put(:remote_ip, ip)
      |> put_req_header("user-agent", @browser_ua)

    %{conn: conn}
  end

  defp beacon(conn, params), do: post(conn, ~p"/api/read", params)

  defp views(path), do: Repo.one(from v in PageView, where: v.path == ^path, select: sum(v.views))

  describe "POST /api/read" do
    test "counts a view of a real page and keeps only the outside referrer's host", %{conn: conn} do
      conn =
        beacon(conn, %{
          "path" => "/about",
          "referrer" => "https://www.News.YCombinator.com/item?id=1"
        })

      assert response(conn, 204)
      assert [%{referrer_host: "news.ycombinator.com", views: 1}] = Repo.all(PageView)
    end

    test "treats same-site and missing referrers as direct", %{conn: conn} do
      beacon(conn, %{"path" => "/about", "referrer" => "http://www.example.com/topics"})
      beacon(conn, %{"path" => "/about"})

      assert [%{referrer_host: "", views: 2}] = Repo.all(PageView)
    end

    test "ignores paths the site doesn't serve as pages, but still answers 204", %{conn: conn} do
      for path <- ["/no-such-page", "/page-views", "/api/read", "/health", "nope", ""] do
        assert conn |> beacon(%{"path" => path}) |> response(204)
      end

      assert conn |> beacon(%{}) |> response(204)
      assert Repo.aggregate(PageView, :count) == 0
    end

    test "ignores bots and requests with no user agent", %{conn: conn} do
      conn
      |> put_req_header("user-agent", "Mozilla/5.0 (compatible; Googlebot/2.1)")
      |> beacon(%{"path" => "/about"})

      conn
      |> delete_req_header("user-agent")
      |> beacon(%{"path" => "/about"})

      assert views("/about") == nil
    end

    test "rate limits a single IP", %{conn: conn} do
      limit = Application.fetch_env!(:algorithms_for_optimization, :page_view_rate_limit)[:limit]

      for _ <- 1..(limit + 5), do: beacon(conn, %{"path" => "/about"})

      assert views("/about") == limit
    end
  end

  describe "GET /page-views" do
    test "requires basic auth", %{conn: conn} do
      assert conn |> get(~p"/page-views") |> response(401)
    end

    test "shows totals, pages and referrers with the configured credentials", %{conn: conn} do
      beacon(conn, %{"path" => "/littles-law", "referrer" => "https://news.ycombinator.com/"})

      page =
        conn
        |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "secret"))
        |> get(~p"/page-views")
        |> html_response(200)
        |> LazyHTML.from_document()

      text = fn selector -> page |> LazyHTML.query(selector) |> LazyHTML.text() end

      assert text.("#stats-total") =~ "1"
      assert text.("#stats-top-page") =~ "/littles-law"
      assert page |> LazyHTML.query("#stats-daily-chart .lbm-stats-col") |> Enum.count() == 30
      assert text.("#top-pages") =~ "/littles-law"
      assert text.("#top-referrers") =~ "news.ycombinator.com"
    end

    test "renders an empty state before anything is counted", %{conn: conn} do
      page =
        conn
        |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "secret"))
        |> get(~p"/page-views")
        |> html_response(200)
        |> LazyHTML.from_document()

      assert page |> LazyHTML.query("#stats-total") |> LazyHTML.text() =~ "0"
      assert page |> LazyHTML.query("#top-pages .lbm-stats-empty") |> Enum.any?()
    end

    test "is hidden from crawlers", %{conn: conn} do
      body = conn |> get("/robots.txt") |> response(200)
      assert body =~ "Disallow: /page-views"
      assert body =~ "Disallow: /api/"
    end
  end
end
