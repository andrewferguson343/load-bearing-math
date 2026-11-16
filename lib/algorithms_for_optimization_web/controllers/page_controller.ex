defmodule AlgorithmsForOptimizationWeb.PageController do
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.{Collections, Topics}

  def home(conn, _params) do
    render(conn, :home,
      featured: Topics.featured(),
      recent: Topics.recent(5),
      collections: Enum.map(Collections.grid(), &collection_card/1),
      foundations_collection: Collections.fetch!(:foundations),
      # Registry order is the suggested reading order.
      foundations: Topics.in_collection(:foundations) |> Enum.take(4),
      point_loads_collection: Collections.fetch!(:point_loads),
      point_loads: Topics.by_kind(:point_load) |> Enum.take(4),
      today: Date.utc_today()
    )
  end

  def about(conn, _params) do
    render(conn, :about,
      page_title: "About",
      page_description:
        "Load Bearing Math demystifies the math behind everyday systems. Written by Andrew Ferguson, a computer scientist with a minor in mathematics who tutors math and computer science."
    )
  end

  def privacy(conn, _params) do
    render(conn, :privacy,
      contact_email: Application.fetch_env!(:algorithms_for_optimization, :contact_email),
      page_title: "Privacy",
      page_description:
        "What Load Bearing Math collects, why, and how to have it deleted. No analytics, no ads, no tracking."
    )
  end

  def topics(conn, _params) do
    visible = Topics.visible()

    groups =
      for collection <- Collections.all(),
          topics = Enum.filter(visible, &(&1.collection == collection.id)),
          topics != [],
          do: {collection, topics}

    ungrouped = Enum.filter(visible, &is_nil(&1.collection))

    render(conn, :topics,
      groups: groups,
      ungrouped: ungrouped,
      page_title: "Topics",
      page_description:
        "Every Load Bearing Math series in one place, each one a short, hands-on walkthrough of the math behind everyday engineering."
    )
  end

  def collection(conn, %{"slug" => slug}) do
    collection = Collections.get_by_slug(slug) || raise AlgorithmsForOptimizationWeb.NotFoundError

    render(conn, :collection,
      collection: collection,
      topics: Topics.in_collection(collection.id),
      upcoming: Topics.upcoming_count(collection.id),
      page_title: collection.name,
      page_description: collection.description
    )
  end

  defp collection_card(collection) do
    %{
      collection: collection,
      count: length(Topics.in_collection(collection.id)),
      upcoming: Topics.upcoming_count(collection.id)
    }
  end
end
