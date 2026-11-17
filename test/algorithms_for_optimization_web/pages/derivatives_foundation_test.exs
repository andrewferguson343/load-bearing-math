defmodule AlgorithmsForOptimizationWeb.DerivativesFoundationTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests, so it keeps checking the
  # right thing once the foundation goes public.
  if Topics.public?(:derivatives) do
    test "renders the overview without the end note", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/derivatives")

      assert has_element?(view, "#page-heading")
      refute has_element?(view, "#topic-end-note")
    end

    test "renders the slope lesson with its charts", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/derivatives-slope")

      assert has_element?(view, "#page-heading")
      assert has_element?(view, "#curve-chart")
      assert has_element?(view, "#tangent-line-chart")
      refute has_element?(view, "#topic-end-note")
    end

    test "renders the middle lessons without the end note", %{conn: conn} do
      for path <- [~p"/derivatives-chain-rule", ~p"/derivatives-second-derivatives"] do
        {:ok, view, _html} = live(conn, path)

        assert has_element?(view, "#page-heading")
        refute has_element?(view, "#topic-end-note")
      end
    end

    test "renders the last lesson with the end note", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/derivatives-optimal-value")

      assert has_element?(view, "#page-heading")
      assert has_element?(view, "#topic-end-note")
    end

    test "appears in the Foundations strip on the landing page", %{conn: conn} do
      html = conn |> get(~p"/") |> html_response(200)
      assert html =~ ~s(id="foundation-derivatives")
    end
  else
    test "redirects home while the Derivatives foundation is gated", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, ~p"/derivatives")

      for path <- [
            ~p"/derivatives-slope",
            ~p"/derivatives-chain-rule",
            ~p"/derivatives-second-derivatives",
            ~p"/derivatives-optimal-value"
          ] do
        assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, path)
      end
    end
  end

  test "is registered as a foundation that the Optimization series builds on" do
    assert %{kind: :foundation, collection: :foundations} = Topics.fetch!(:derivatives)
    assert :derivatives in Topics.fetch!(:optimization).prerequisites
  end
end
