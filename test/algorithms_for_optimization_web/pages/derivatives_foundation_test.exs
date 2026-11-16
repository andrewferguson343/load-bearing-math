defmodule AlgorithmsForOptimizationWeb.DerivativesFoundationTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests, so it keeps checking the
  # right thing once the foundation goes public.
  if Topics.public?(:derivatives) do
    test "renders the foundation with its charts and the end note", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/derivatives")

      assert has_element?(view, "#page-heading")
      assert has_element?(view, "#curve-chart")
      assert has_element?(view, "#tangent-line-chart")
      assert has_element?(view, "#topic-end-note")
    end

    test "appears in the Foundations strip on the landing page", %{conn: conn} do
      html = conn |> get(~p"/") |> html_response(200)
      assert html =~ ~s(id="foundation-derivatives")
    end
  else
    test "redirects home while the Derivatives foundation is gated", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, ~p"/derivatives")
    end
  end

  test "is registered as a foundation that the Optimization series builds on" do
    assert %{kind: :foundation, collection: :foundations} = Topics.fetch!(:derivatives)
    assert :derivatives in Topics.fetch!(:optimization).prerequisites
  end
end
