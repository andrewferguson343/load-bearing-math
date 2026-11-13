defmodule AlgorithmsForOptimizationWeb.CanonicalHostTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  alias AlgorithmsForOptimizationWeb.Endpoint

  defp request_on(conn, host, path), do: get(%{conn | host: host}, path)

  test "redirects www to the bare domain, keeping path and query", %{conn: conn} do
    conn = request_on(conn, "www." <> Endpoint.host(), "/topics?ref=twitter")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == [Endpoint.url() <> "/topics?ref=twitter"]
  end

  test "redirects the www home page", %{conn: conn} do
    conn = request_on(conn, "www." <> Endpoint.host(), "/")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == [Endpoint.url() <> "/"]
  end

  test "leaves the bare domain alone", %{conn: conn} do
    conn = request_on(conn, Endpoint.host(), "/topics")

    assert conn.status == 200
  end

  test "leaves other www hosts alone", %{conn: conn} do
    conn = request_on(conn, "www.example.com", "/health")

    assert conn.status == 200
  end
end
