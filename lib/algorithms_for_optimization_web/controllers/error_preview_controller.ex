defmodule AlgorithmsForOptimizationWeb.ErrorPreviewController do
  @moduledoc """
  Dev-only preview of the branded error pages (routed under /dev, which only exists when
  `dev_routes` is on). Real errors in dev show Phoenix's debug page instead.
  """
  use AlgorithmsForOptimizationWeb, :controller

  def show(conn, %{"status" => status}) when status in ["404", "500"] do
    conn
    |> put_status(String.to_integer(status))
    |> put_root_layout(false)
    |> put_layout(false)
    |> put_view(html: AlgorithmsForOptimizationWeb.ErrorHTML)
    |> render(:"#{status}")
  end

  def show(conn, _params) do
    conn
    |> put_status(:not_found)
    |> text("Preview available for 404 and 500 only.")
  end
end
