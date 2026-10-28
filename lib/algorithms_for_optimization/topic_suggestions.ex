defmodule AlgorithmsForOptimization.TopicSuggestions do
  @moduledoc """
  Captures topic suggestions from site visitors.
  """

  import Ecto.Query

  alias AlgorithmsForOptimization.Repo
  alias AlgorithmsForOptimization.TopicSuggestion

  def submit(text) when is_binary(text) do
    trimmed = String.trim(text)

    if trimmed == "" do
      :error
    else
      %TopicSuggestion{}
      |> TopicSuggestion.changeset(%{text: trimmed})
      |> Repo.insert()
      |> case do
        {:ok, _suggestion} -> :ok
        {:error, _changeset} -> :error
      end
    end
  end

  @doc "All suggestions, newest first."
  def list do
    Repo.all(from s in TopicSuggestion, order_by: [desc: s.inserted_at])
  end
end
