defmodule AlgorithmsForOptimizationWeb.HealthController do
  @moduledoc """
  `GET /health` for Railway's deploy health check (configured in railway.json).

  Returns 200 when the app is up and can reach the database, 503 otherwise. Railway only
  switches traffic to a new release once this returns 200, so a release that can't boot or
  can't reach Postgres never replaces a working one.

  Routed outside the browser pipeline (no session, CSRF or HTML), and excluded from the
  HTTPS redirect in config/prod.exs because Railway checks it over plain HTTP.
  """
  use AlgorithmsForOptimizationWeb, :controller

  require Logger

  alias AlgorithmsForOptimization.Repo

  def show(conn, _params) do
    case database_check() do
      :ok ->
        conn
        |> put_resp_header("cache-control", "no-store")
        |> json(%{status: "ok"})

      {:error, reason} ->
        Logger.error("Health check failed: database unreachable: #{inspect(reason)}")

        conn
        |> put_resp_header("cache-control", "no-store")
        |> put_status(:service_unavailable)
        |> json(%{status: "error", checks: %{database: "unreachable"}})
    end
  end

  defp database_check do
    case Repo.query("SELECT 1", [], timeout: 2_000) do
      {:ok, _result} -> :ok
      {:error, error} -> {:error, error}
    end
  rescue
    # e.g. DBConnection.ConnectionError when the pool can't check out a connection
    error -> {:error, error}
  end
end
