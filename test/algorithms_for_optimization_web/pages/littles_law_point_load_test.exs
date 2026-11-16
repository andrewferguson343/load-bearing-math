defmodule AlgorithmsForOptimizationWeb.LittlesLawPointLoadTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests, so it keeps checking the
  # right thing once the Point Load goes public.
  if Topics.public?(:littles_law) do
    test "renders the Point Load with the end note", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/littles-law")

      assert has_element?(view, "#page-heading")
      assert has_element?(view, "#topic-end-note")
    end

    test "appears in the Point Loads strip on the landing page", %{conn: conn} do
      html = conn |> get(~p"/") |> html_response(200)
      assert html =~ ~s(id="point-load-littles_law")
    end
  else
    test "redirects home while the Little's Law Point Load is gated", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, ~p"/littles-law")
    end
  end

  test "is registered as a Point Load" do
    assert %{kind: :point_load, collection: :point_loads} = Topics.fetch!(:littles_law)
  end
end
