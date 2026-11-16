defmodule AlgorithmsForOptimizationWeb.WorkControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  alias AlgorithmsForOptimization.{Repo, WorkInquiry}

  # Every test posts from its own made-up IP so rate-limit counts never leak between tests.
  setup %{conn: conn} do
    ip = {10, :rand.uniform(254), :rand.uniform(254), :rand.uniform(254)}
    {:ok, conn: %{conn | remote_ip: ip}}
  end

  @valid %{
    "name" => " Grace Hopper ",
    "email" => "grace@example.com",
    "organization" => "Navy",
    "message" => "We need help with a compiler."
  }

  defp doc(html), do: LazyHTML.from_document(html)
  defp has?(doc, selector), do: doc |> LazyHTML.query(selector) |> Enum.any?()
  defp send_inquiry(conn, params), do: post(conn, ~p"/work-with-me", params)
  defp count, do: Repo.aggregate(WorkInquiry, :count)

  test "GET /work-with-me shows the areas and a free-text form", %{conn: conn} do
    page = conn |> get(~p"/work-with-me") |> html_response(200) |> doc()

    assert has?(page, "#work-areas")
    assert has?(page, ~s(#work-form textarea[name="work[message]"]))
    refute has?(page, "#work-form select")
  end

  test "is linked from the landing footer and the About page", %{conn: conn} do
    assert conn
           |> get(~p"/")
           |> html_response(200)
           |> doc()
           |> has?(~s(#footer-work[href="/work-with-me"]))

    assert conn
           |> get(~p"/about")
           |> html_response(200)
           |> doc()
           |> has?(~s(#about-work-link[href="/work-with-me"]))
  end

  test "saves a valid inquiry (organization optional)", %{conn: conn} do
    conn = send_inquiry(conn, %{"work" => @valid})
    assert redirected_to(conn) == ~p"/work-with-me"
    assert [%WorkInquiry{name: "Grace Hopper", organization: "Navy"}] = Repo.all(WorkInquiry)

    send_inquiry(conn, %{"work" => Map.delete(@valid, "organization")})
    assert count() == 2
  end

  test "re-renders with errors and saves nothing when invalid", %{conn: conn} do
    conn = send_inquiry(conn, %{"work" => %{@valid | "email" => "nope", "message" => ""}})

    assert conn |> html_response(422) |> doc() |> has?("#work-form")
    assert count() == 0
  end

  test "drops honeypot submissions silently", %{conn: conn} do
    conn = send_inquiry(conn, %{"work" => @valid, "company_website" => "http://spam.example"})

    assert redirected_to(conn) == ~p"/work-with-me"
    assert count() == 0
  end

  test "rate limits a single IP", %{conn: conn} do
    limit = Application.fetch_env!(:algorithms_for_optimization, :inquiry_rate_limit)[:limit]

    for _ <- 1..limit, do: send_inquiry(conn, %{"work" => @valid})
    conn = send_inquiry(conn, %{"work" => @valid})

    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "few minutes"
    assert count() == limit
  end

  test "the inquiry list needs admin auth", %{conn: conn} do
    send_inquiry(conn, %{"work" => @valid})

    assert conn |> get(~p"/work-inquiries") |> response(401)

    body =
      conn
      |> put_req_header("authorization", Plug.BasicAuth.encode_basic_auth("admin", "secret"))
      |> get(~p"/work-inquiries")
      |> response(200)

    assert body =~ "Grace Hopper <grace@example.com>\tNavy"
  end
end
