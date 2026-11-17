defmodule AlgorithmsForOptimization.PageView do
  @moduledoc """
  A daily view count for one path from one referrer host. See `AlgorithmsForOptimization.Analytics`.
  """
  use Ecto.Schema

  schema "page_views" do
    field :day, :date
    field :path, :string
    field :referrer_host, :string, default: ""
    field :views, :integer, default: 0
  end
end
