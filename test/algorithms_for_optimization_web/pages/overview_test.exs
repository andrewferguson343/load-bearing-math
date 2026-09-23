defmodule AlgorithmsForOptimizationWeb.MathematicsOverviewTest do
  use AlgorithmsForOptimizationWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders the overiew page", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/overview")
    assert html =~ "Overview"
  end
end
