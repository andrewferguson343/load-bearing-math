defmodule AlgorithmsForOptimization.TopicSuggestion do
  use Ecto.Schema
  import Ecto.Changeset

  # Matches the varchar(255) column; longer input would otherwise crash the insert.
  @max_length 255

  schema "topic_suggestions" do
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  def max_length, do: @max_length

  def changeset(suggestion, attrs) do
    suggestion
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, max: @max_length)
  end
end
