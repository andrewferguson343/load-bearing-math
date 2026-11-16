defmodule AlgorithmsForOptimization.Repo.Migrations.CreateWorkInquiries do
  use Ecto.Migration

  def change do
    create table(:work_inquiries) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :organization, :string
      add :message, :text, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
