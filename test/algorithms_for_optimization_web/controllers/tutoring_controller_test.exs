defmodule AlgorithmsForOptimizationWeb.TutoringControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  alias AlgorithmsForOptimization.{Repo, Services, TutoringInquiry}

  # Every test posts from its own made-up IP so rate-limit counts never leak between tests.
  setup %{conn: conn} do
    ip = {10, :rand.uniform(254), :rand.uniform(254), :rand.uniform(254)}
    {:ok, conn: %{conn | remote_ip: ip}}
  end

  @valid %{
    "name" => "  Ada Lovelace ",
    "email" => "ada@example.com",
    "offering" => "tier_two",
    "message" => "Help with linear algebra, please."
  }

  defp doc(html), do: LazyHTML.from_document(html)
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()
  defp inquire(conn, params), do: post(conn, ~p"/tutoring/inquiries", params)
  defp inquiry_count, do: Repo.aggregate(TutoringInquiry, :count)

  describe "GET /tutoring" do
    test "shows every offering and the inquiry form", %{conn: conn} do
      page = conn |> get(~p"/tutoring") |> html_response(200) |> doc()

      assert has?(page, "#services-hero")

      for offering <- Services.offerings() do
        assert has?(page, "#offering-#{offering.id}")

        assert page
               |> LazyHTML.query("#offering-#{offering.id} .lbm-offering-best-for")
               |> LazyHTML.text() =~
                 offering.best_for
      end

      assert has?(page, ~s(#inquiry-form[action="/tutoring/inquiries#inquiry"]))
      assert has?(page, "#inquiry-form select[name='inquiry[offering]']")
    end

    test "links to published lessons as proof, never gated ones", %{conn: conn} do
      page = conn |> get(~p"/tutoring") |> html_response(200) |> doc()

      assert has?(page, "#proof-cosine_similarity")
      refute has?(page, "#proof-pagerank")
    end
  end

  describe "GET /services" do
    test "is a hub that leads with engineering, then tutoring", %{conn: conn} do
      page = conn |> get(~p"/services") |> html_response(200) |> doc()

      assert has?(page, ~s(#services-engineering[href="/work-with-me"]))
      assert has?(page, ~s(#services-tutoring[href="/tutoring"]))

      ids = page |> LazyHTML.query("#services-paths > a") |> LazyHTML.attribute("id")
      assert ids == ["services-engineering", "services-tutoring"]
    end

    test "is in the header nav", %{conn: conn} do
      page = conn |> get(~p"/") |> html_response(200) |> doc()
      assert has?(page, ~s(.lbm-nav a[href="/services"]))
    end
  end

  describe "POST /tutoring/inquiries" do
    test "saves a valid inquiry and redirects back", %{conn: conn} do
      conn = inquire(conn, %{"inquiry" => @valid})

      assert redirected_to(conn) == ~p"/tutoring"
      assert Phoenix.Flash.get(conn.assigns.flash, :info)

      assert [%TutoringInquiry{name: "Ada Lovelace", offering: "tier_two"}] =
               Repo.all(TutoringInquiry)
    end

    test "allows \"not sure yet\" (no offering)", %{conn: conn} do
      inquire(conn, %{"inquiry" => Map.put(@valid, "offering", "")})
      assert [%TutoringInquiry{offering: nil}] = Repo.all(TutoringInquiry)
    end

    test "re-renders with errors for missing fields and a bad email", %{conn: conn} do
      conn = inquire(conn, %{"inquiry" => %{@valid | "name" => " ", "email" => "nope"}})

      page = conn |> html_response(422) |> doc()
      assert has?(page, "#inquiry-form")
      assert page |> LazyHTML.query("#inquiry-form") |> LazyHTML.text() =~ "email address"
      assert inquiry_count() == 0
    end

    test "rejects an unknown offering", %{conn: conn} do
      conn = inquire(conn, %{"inquiry" => %{@valid | "offering" => "free_lunch"}})

      assert html_response(conn, 422)
      assert inquiry_count() == 0
    end

    test "invalid submissions don't count toward the rate limit", %{conn: conn} do
      limit = Application.fetch_env!(:algorithms_for_optimization, :inquiry_rate_limit)[:limit]

      for _ <- 1..(limit + 2), do: inquire(conn, %{"inquiry" => %{@valid | "email" => "typo"}})
      conn = inquire(conn, %{"inquiry" => @valid})

      assert redirected_to(conn) == ~p"/tutoring"
      assert inquiry_count() == 1
    end

    test "silently drops submissions that fill in the honeypot", %{conn: conn} do
      conn = inquire(conn, %{"inquiry" => @valid, "company_website" => "http://spam.example"})

      assert redirected_to(conn) == ~p"/tutoring"
      assert inquiry_count() == 0
    end

    test "rate limits a single IP", %{conn: conn} do
      limit = Application.fetch_env!(:algorithms_for_optimization, :inquiry_rate_limit)[:limit]

      for _ <- 1..limit, do: inquire(conn, %{"inquiry" => @valid})
      conn = inquire(conn, %{"inquiry" => @valid})

      assert redirected_to(conn) == ~p"/tutoring"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "few minutes"
      assert inquiry_count() == limit
    end
  end

  describe "GET /tutoring-inquiries" do
    test "requires basic auth", %{conn: conn} do
      assert conn |> get(~p"/tutoring-inquiries") |> response(401)
    end

    test "lists inquiries for the admin", %{conn: conn} do
      inquire(conn, %{"inquiry" => @valid})

      body =
        conn
        |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "secret"))
        |> get(~p"/tutoring-inquiries")
        |> response(200)

      assert body =~ "Ada Lovelace <ada@example.com>"
    end
  end
end
