defmodule AlgorithmsForOptimizationWeb.ErrorHTMLTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template, only: [render_to_string: 4]

  alias AlgorithmsForOptimizationWeb.ErrorHTML

  defp render_error(status), do: render_to_string(ErrorHTML, status, "html", [])

  test "404 is a branded, standalone page with a way back" do
    doc = render_error("404") |> LazyHTML.from_document()

    assert doc |> LazyHTML.query("#error-404") |> Enum.count() == 1
    assert doc |> LazyHTML.query("link[rel=stylesheet][href*='app.css']") |> Enum.count() == 1
    assert doc |> LazyHTML.query("a[href='/']") |> Enum.count() >= 1
    assert doc |> LazyHTML.query("a[href='/topics']") |> Enum.count() == 1
    assert doc |> LazyHTML.query("meta[name=robots][content=noindex]") |> Enum.count() == 1
  end

  test "500 is a branded page that loads no JavaScript" do
    html = render_error("500")
    doc = LazyHTML.from_document(html)

    assert doc |> LazyHTML.query("#error-500") |> Enum.count() == 1
    assert doc |> LazyHTML.query("script") |> Enum.count() == 0
  end

  test "other statuses keep the plain-text default" do
    assert render_error("403") == "Forbidden"
  end

  test "an unknown route renders the branded 404 when debug errors are off", %{conn: conn} do
    # Test config doesn't set debug_errors, so this goes through ErrorHTML like production.
    body = conn |> get("/no-such-page") |> html_response(404)
    assert body =~ ~s(id="error-404")
  end
end
