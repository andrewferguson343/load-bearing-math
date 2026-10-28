defmodule AlgorithmsForOptimization.TopicSuggestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_suggestions" do
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(suggestion, attrs) do
    suggestion
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
