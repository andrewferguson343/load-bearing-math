defmodule AlgorithmsForOptimization.TutoringInquiries do
  @moduledoc "Tutoring inquiries from the Services page."

  import Ecto.Query

  alias AlgorithmsForOptimization.{Repo, TutoringInquiry}

  def change(attrs \\ %{}), do: TutoringInquiry.changeset(%TutoringInquiry{}, attrs)

  @doc "Saves an inquiry. Returns `{:ok, inquiry}` or `{:error, changeset}`."
  def submit(attrs) do
    attrs |> change() |> Repo.insert()
  end

  @doc "All inquiries, newest first."
  def list do
    Repo.all(from i in TutoringInquiry, order_by: [desc: i.inserted_at, desc: i.id])
  end
end
