defmodule AlgorithmsForOptimization.Repo.Migrations.CreatePageViews do
  use Ecto.Migration

  # Aggregate counts only: one row per (day, path, referrer host). Nothing here identifies a
  # visitor. An empty referrer_host means direct or same-site traffic; it's "" rather than NULL
  # so the unique index (and the upsert that increments it) treats it as one bucket.
  def change do
    create table(:page_views) do
      add :day, :date, null: false
      add :path, :string, null: false
      add :referrer_host, :string, null: false, default: ""
      add :views, :integer, null: false, default: 0
    end

    create unique_index(:page_views, [:day, :path, :referrer_host])
  end
end
