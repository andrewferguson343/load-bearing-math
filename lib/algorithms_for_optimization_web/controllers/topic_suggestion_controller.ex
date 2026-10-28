defmodule AlgorithmsForOptimizationWeb.TopicSuggestionController do
  use AlgorithmsForOptimizationWeb, :controller

  def index(conn, _params) do
    body =
      AlgorithmsForOptimization.TopicSuggestions.list()
      |> Enum.map(fn s -> "#{s.inserted_at}\t#{s.text}" end)
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end

  def create(conn, params) do
    case AlgorithmsForOptimization.TopicSuggestions.submit(params["suggestion"] || "") do
      :ok ->
        conn
        |> put_flash(:info, "Thanks, got it. We'll take a look.")
        |> redirect(to: ~p"/")

      :error ->
        conn
        |> put_flash(:error, "Type something first.")
        |> redirect(to: ~p"/")
    end
  end
end
