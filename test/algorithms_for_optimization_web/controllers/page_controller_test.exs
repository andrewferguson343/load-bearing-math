defmodule AlgorithmsForOptimizationWeb.PageControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Behind It All"
  end
end
