defmodule AlgorithmsForOptimizationWeb.NotFoundError do
  @moduledoc "Raise from a controller to render the branded 404 page (e.g. an unknown collection slug)."
  defexception message: "not found", plug_status: 404
end
