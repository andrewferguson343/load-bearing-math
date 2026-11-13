defmodule AlgorithmsForOptimization.TopicSuggestions do
  @moduledoc """
  Captures topic suggestions from site visitors.
  """

  import Ecto.Query

  alias AlgorithmsForOptimization.Repo
  alias AlgorithmsForOptimization.TopicSuggestion

  @doc """
  Saves a suggestion. Returns `:ok`, `{:error, :blank}` or `{:error, :too_long}`.
  """
  def submit(text) when is_binary(text) do
    trimmed = String.trim(text)

    if trimmed == "" do
      {:error, :blank}
    else
      %TopicSuggestion{}
      |> TopicSuggestion.changeset(%{text: trimmed})
      |> Repo.insert()
      |> case do
        {:ok, _suggestion} -> :ok
        {:error, changeset} -> {:error, error_reason(changeset)}
      end
    end
  end

  def submit(_not_a_string), do: {:error, :blank}

  defp error_reason(changeset) do
    case changeset.errors[:text] do
      {_message, opts} -> if opts[:validation] == :length, do: :too_long, else: :blank
      nil -> :blank
    end
  end

  @doc "All suggestions, newest first."
  def list do
    Repo.all(from s in TopicSuggestion, order_by: [desc: s.inserted_at])
  end
end
