defmodule AlgorithmsForOptimization.Repo.Migrations.CreateTopicSuggestions do
  use Ecto.Migration

  def change do
    create table(:topic_suggestions) do
      add :text, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
