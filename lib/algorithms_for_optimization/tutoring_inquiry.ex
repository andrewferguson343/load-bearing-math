defmodule AlgorithmsForOptimization.TutoringInquiry do
  @moduledoc "Someone asking about tutoring through the form on /services."
  use Ecto.Schema
  import Ecto.Changeset

  alias AlgorithmsForOptimization.Services

  @max_message 4000

  schema "tutoring_inquiries" do
    field :name, :string
    field :email, :string

    # Id of the offering they picked (see `AlgorithmsForOptimization.Services`), or nil for "not sure".
    field :offering, :string
    field :message, :string

    timestamps(type: :utc_datetime)
  end

  def max_message, do: @max_message

  def changeset(inquiry, attrs) do
    inquiry
    |> cast(attrs, [:name, :email, :offering, :message])
    |> update_change(:name, &String.trim/1)
    |> update_change(:email, &String.trim/1)
    |> update_change(:message, &String.trim/1)
    |> validate_required([:name, :email, :message])
    |> validate_length(:name, max: 120)
    |> validate_length(:email, max: 254)
    |> validate_format(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      message: "doesn't look like an email address"
    )
    |> validate_length(:message, max: @max_message)
    |> validate_inclusion(:offering, Enum.map(Services.offerings(), &to_string(&1.id)))
  end
end
