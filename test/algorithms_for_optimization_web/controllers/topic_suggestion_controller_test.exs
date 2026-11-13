defmodule AlgorithmsForOptimizationWeb.TopicSuggestionControllerTest do
  # Not async: one test flips the global :trust_x_forwarded_for setting.
  use AlgorithmsForOptimizationWeb.ConnCase, async: false

  alias AlgorithmsForOptimization.Repo
  alias AlgorithmsForOptimization.TopicSuggestion

  # Every test posts from its own made-up IP so rate-limit counts never leak between tests.
  setup %{conn: conn} do
    ip = {10, :rand.uniform(254), :rand.uniform(254), :rand.uniform(254)}
    {:ok, conn: %{conn | remote_ip: ip}}
  end

  defp suggestion_count, do: Repo.aggregate(TopicSuggestion, :count)

  defp suggest(conn, params), do: post(conn, ~p"/topic-suggestions", params)

  test "saves a suggestion and thanks the visitor", %{conn: conn} do
    conn = suggest(conn, %{"suggestion" => "  Kalman filters  "})

    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Thanks"
    assert [%TopicSuggestion{text: "Kalman filters"}] = Repo.all(TopicSuggestion)
  end

  test "rejects a blank suggestion", %{conn: conn} do
    conn = suggest(conn, %{"suggestion" => "   "})

    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Type something"
    assert suggestion_count() == 0
  end

  test "rejects an over-long suggestion instead of crashing", %{conn: conn} do
    too_long = String.duplicate("a", TopicSuggestion.max_length() + 1)
    conn = suggest(conn, %{"suggestion" => too_long})

    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "characters"
    assert suggestion_count() == 0
  end

  test "accepts a suggestion at exactly the max length", %{conn: conn} do
    conn = suggest(conn, %{"suggestion" => String.duplicate("a", TopicSuggestion.max_length())})

    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Thanks"
    assert suggestion_count() == 1
  end

  test "silently drops submissions that fill in the honeypot", %{conn: conn} do
    conn = suggest(conn, %{"suggestion" => "buy cheap watches", "website" => "http://spam.example"})

    # Looks like a success to the bot...
    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Thanks"
    # ...but nothing is stored.
    assert suggestion_count() == 0
  end

  test "rate limits a single IP after 5 posts in the window", %{conn: conn} do
    for n <- 1..5 do
      assert conn |> suggest(%{"suggestion" => "topic #{n}"}) |> redirected_to() == ~p"/"
    end

    conn = suggest(conn, %{"suggestion" => "topic 6"})

    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "few minutes"
    assert suggestion_count() == 5
  end

  test "a rate-limited IP doesn't block other visitors", %{conn: conn} do
    for n <- 1..6, do: suggest(conn, %{"suggestion" => "topic #{n}"})

    other = %{conn | remote_ip: {192, 0, 2, 77}}
    assert other |> suggest(%{"suggestion" => "a different visitor"}) |> Map.get(:status) == 302
    assert suggestion_count() == 6
  end

  describe "behind a proxy (trust_x_forwarded_for)" do
    setup do
      previous = Application.get_env(:algorithms_for_optimization, :trust_x_forwarded_for)
      Application.put_env(:algorithms_for_optimization, :trust_x_forwarded_for, true)

      on_exit(fn ->
        Application.put_env(:algorithms_for_optimization, :trust_x_forwarded_for, previous || false)
      end)
    end

    test "limits by the right-most X-Forwarded-For address, not the proxy's", %{conn: conn} do
      visitor = "203.0.113.#{:rand.uniform(254)}"

      # A spoofed left-most entry changes on every request; the proxy-appended right-most one doesn't.
      for n <- 1..5 do
        conn
        |> put_req_header("x-forwarded-for", "198.51.100.#{n}, #{visitor}")
        |> suggest(%{"suggestion" => "topic #{n}"})
      end

      conn =
        conn
        |> put_req_header("x-forwarded-for", "198.51.100.99, #{visitor}")
        |> suggest(%{"suggestion" => "topic 6"})

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "few minutes"
      assert suggestion_count() == 5
    end
  end
end
