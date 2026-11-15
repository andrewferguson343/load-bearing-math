defmodule AlgorithmsForOptimization.Repo.Migrations.CreateTutoringInquiries do
  use Ecto.Migration

  def change do
    create table(:tutoring_inquiries) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :offering, :string
      add :message, :text, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
