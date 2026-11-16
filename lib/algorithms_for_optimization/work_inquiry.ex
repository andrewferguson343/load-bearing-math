defmodule AlgorithmsForOptimization.WorkInquiry do
  @moduledoc "Someone reaching out through /work-with-me about consulting, advice or employment."
  use Ecto.Schema
  import Ecto.Changeset

  @max_message 4000

  schema "work_inquiries" do
    field :name, :string
    field :email, :string
    field :organization, :string
    field :message, :string

    timestamps(type: :utc_datetime)
  end

  def max_message, do: @max_message

  def changeset(inquiry, attrs) do
    inquiry
    |> cast(attrs, [:name, :email, :organization, :message])
    |> update_change(:name, &String.trim/1)
    |> update_change(:email, &String.trim/1)
    |> update_change(:organization, &String.trim/1)
    |> update_change(:message, &String.trim/1)
    |> validate_required([:name, :email, :message])
    |> validate_length(:name, max: 120)
    |> validate_length(:email, max: 254)
    |> validate_length(:organization, max: 160)
    |> validate_format(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      message: "doesn't look like an email address"
    )
    |> validate_length(:message, max: @max_message)
  end
end
