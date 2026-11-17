defmodule AlgorithmsForOptimizationWeb.PageController do
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.{Collections, Tags, Topics}

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
      today: Date.utc_today(),
      # Dev builds show reminders where empty sections are hidden on the live site.
      dev_routes?: Application.get_env(:algorithms_for_optimization, :dev_routes, false)
    )
  end

  def about(conn, _params) do
    render(conn, :about,
      page_title: "About",
      page_description:
        "Andrew Ferguson, the software engineer behind Load Bearing Math, on the math that systems quietly depend on and how he works and teaches.",
      json_ld: AlgorithmsForOptimizationWeb.SEO.person_json_ld()
    )
  end

  def services(conn, _params) do
    render(conn, :services,
      page_title: "Services",
      page_description:
        "Engineering engagements on hard systems problems, plus one-on-one math and computer science tutoring."
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

    render(conn, :topics,
      groups: grouped_by_collection(visible),
      ungrouped: Enum.filter(visible, &is_nil(&1.collection)),
      kinds: Topics.used_kinds(),
      tags: Topics.used_tags(),
      page_title: "Topics",
      page_description:
        "Every Load Bearing Math topic in one place, each one a short, hands-on walkthrough of the math behind everyday engineering."
    )
  end

  # The Articles type page: every visible multi-part topic, grouped like the Topics page.
  # Foundations and Point Loads are listed by their collection pages instead.
  def articles(conn, _params) do
    articles = Enum.filter(Topics.visible(), &(&1.kind == :series))

    render(conn, :articles,
      groups: grouped_by_collection(articles),
      ungrouped: Enum.filter(articles, &is_nil(&1.collection)),
      kinds: Topics.used_kinds(),
      tags: Topics.used_tags(),
      page_title: "Articles",
      page_description:
        "Every Load Bearing Math article: multi-part, hands-on walkthroughs of the math behind everyday engineering, grouped by what it's used for."
    )
  end

  # {collection, topics} pairs in collection order, skipping collections with nothing to show.
  defp grouped_by_collection(topics) do
    for collection <- Collections.all(),
        in_collection = Enum.filter(topics, &(&1.collection == collection.id)),
        in_collection != [],
        do: {collection, in_collection}
  end

  def tag(conn, %{"slug" => slug}) do
    tag = Tags.get_by_slug(slug) || raise AlgorithmsForOptimizationWeb.NotFoundError

    render(conn, :tag,
      tag: tag,
      topics: Topics.with_tag(tag.id),
      other_tags: Enum.reject(Topics.used_tags(), &(&1.id == tag.id)),
      page_title: tag.label,
      page_description:
        "Every Load Bearing Math topic that uses #{tag.label}: short, hands-on walkthroughs of the math behind everyday systems."
    )
  end

  def collection(conn, %{"slug" => slug}) do
    collection = Collections.get_by_slug(slug) || raise AlgorithmsForOptimizationWeb.NotFoundError

    kind = Enum.find(Topics.kinds(), &(&1[:collection] == collection.id))

    render(conn, :collection,
      collection: collection,
      topics: Topics.in_collection(collection.id),
      kinds: Topics.used_kinds(),
      active_kind: kind && kind.id,
      upcoming: Topics.upcoming_count(collection.id),
      page_title: collection.name,
      page_description:
        "#{collection.description} Short, hands-on walkthroughs from Load Bearing Math."
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
