defmodule AlgorithmsForOptimizationWeb.ContentSecurityPolicyTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  defp csp(conn), do: conn |> get_resp_header("content-security-policy") |> List.first()

  defp script_nonce(html) do
    html
    |> LazyHTML.from_document()
    |> LazyHTML.query("script[nonce]")
    |> LazyHTML.attribute("nonce")
    |> List.first()
  end

  test "pages get a CSP whose nonce matches the inline theme script", %{conn: conn} do
    conn = get(conn, ~p"/")
    header = csp(conn)

    assert header =~ "default-src 'self'"
    assert header =~ "object-src 'none'"
    assert header =~ "frame-ancestors 'none'"

    nonce = script_nonce(html_response(conn, 200))
    assert is_binary(nonce) and byte_size(nonce) >= 16
    assert header =~ "script-src 'self' 'nonce-#{nonce}'"
  end

  test "the nonce is different on every request", %{conn: conn} do
    first = conn |> get(~p"/") |> csp()
    second = build_conn() |> get(~p"/") |> csp()

    refute first == second
  end

  test "LiveView pages carry the nonce through to the root layout", %{conn: conn} do
    conn = get(conn, ~p"/cosine-similarity-math")
    nonce = script_nonce(html_response(conn, 200))

    assert csp(conn) =~ "'nonce-#{nonce}'"
    assert {:ok, _view, _html} = live(conn)
  end
end
