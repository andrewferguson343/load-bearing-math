defmodule AlgorithmsForOptimization.WorkInquiries do
  @moduledoc "Consulting, advice and employment inquiries from the Work with me page."

  import Ecto.Query

  alias AlgorithmsForOptimization.{Repo, WorkInquiry}

  def change(attrs \\ %{}), do: WorkInquiry.changeset(%WorkInquiry{}, attrs)

  @doc "Saves an inquiry. Returns `{:ok, inquiry}` or `{:error, changeset}`."
  def submit(attrs), do: attrs |> change() |> Repo.insert()

  @doc "All inquiries, newest first."
  def list do
    Repo.all(from i in WorkInquiry, order_by: [desc: i.inserted_at, desc: i.id])
  end
end
