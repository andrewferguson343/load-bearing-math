defmodule AlgorithmsForOptimizationWeb.TopicSuggestionController do
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.TopicSuggestions
  alias AlgorithmsForOptimizationWeb.{ClientIP, RateLimiter}

  def index(conn, _params) do
    body =
      TopicSuggestions.list()
      |> Enum.map(fn s -> "#{s.inserted_at}\t#{s.text}" end)
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end

  # Name of the hidden honeypot field rendered in the suggest-a-topic form (Layouts.app).
  # People never see it, so any value means a bot filled in every field it found.
  @honeypot_field "website"

  def honeypot_field, do: @honeypot_field

  def create(conn, %{@honeypot_field => value}) when value not in [nil, ""] do
    # Look successful so the bot has no signal to adapt to, but save nothing.
    thanks(conn)
  end

  def create(conn, params) do
    rate_limit =
      Application.fetch_env!(:algorithms_for_optimization, :topic_suggestion_rate_limit)

    with :ok <- RateLimiter.hit({:topic_suggestion, ClientIP.get(conn)}, rate_limit),
         :ok <- TopicSuggestions.submit(params["suggestion"] || "") do
      thanks(conn)
    else
      {:error, :rate_limited} ->
        # A plain redirect (not 429): browsers don't follow a Location header on a 429,
        # so the visitor would be stranded on a blank page instead of seeing this message.
        conn
        |> put_flash(
          :error,
          "That's a lot of suggestions at once. Give it a few minutes and try again."
        )
        |> redirect(to: ~p"/")

      {:error, :too_long} ->
        conn
        |> put_flash(
          :error,
          "Keep it under #{AlgorithmsForOptimization.TopicSuggestion.max_length()} characters, please."
        )
        |> redirect(to: ~p"/")

      {:error, :blank} ->
        conn
        |> put_flash(:error, "Type something first.")
        |> redirect(to: ~p"/")
    end
  end

  defp thanks(conn) do
    conn
    |> put_flash(:info, "Thanks, got it. We'll take a look.")
    |> redirect(to: ~p"/")
  end
end
