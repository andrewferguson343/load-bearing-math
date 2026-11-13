defmodule AlgorithmsForOptimizationWeb.HealthControllerTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  test "GET /health returns 200 when the database is reachable", %{conn: conn} do
    conn = get(conn, ~p"/health")

    assert json_response(conn, 200) == %{"status" => "ok"}
    assert get_resp_header(conn, "cache-control") == ["no-store"]
  end

  test "GET /health doesn't start a session", %{conn: conn} do
    conn = get(conn, ~p"/health")

    assert get_resp_header(conn, "set-cookie") == []
  end
end
