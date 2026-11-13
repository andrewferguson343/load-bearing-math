defmodule AlgorithmsForOptimization.TopicsTest do
  use ExUnit.Case, async: true

  alias AlgorithmsForOptimization.{Collections, Topics}

  test "every topic has the landing page fields and a known collection" do
    collection_ids = Enum.map(Collections.all(), & &1.id)

    for topic <- Topics.all() do
      assert topic.kind in [:series, :point_load], "#{topic.id}: bad kind"
      assert is_nil(topic.collection) or topic.collection in collection_ids, "#{topic.id}"
      assert is_nil(topic.published_on) or match?(%Date{}, topic.published_on)
      assert is_boolean(topic.featured)
    end
  end

  test "collection slugs are unique" do
    slugs = Enum.map(Collections.all(), & &1.slug)
    assert slugs == Enum.uniq(slugs)
  end

  test "recent/1 only returns visible topics" do
    assert Enum.all?(Topics.recent(10), &Topics.public?(&1.id))
  end

  describe "new?/3" do
    test "is true within the window and false outside or without a date" do
      today = ~D[2026-11-13]

      assert Topics.new?(%{published_on: ~D[2026-11-10]}, today)
      refute Topics.new?(%{published_on: ~D[2026-10-01]}, today)
      refute Topics.new?(%{published_on: ~D[2026-11-20]}, today)
      refute Topics.new?(%{published_on: nil}, today)
    end
  end

  test "card_summary/1 falls back to the description" do
    assert Topics.card_summary(%{summary: nil, description: "d"}) == "d"
    assert Topics.card_summary(%{summary: "s", description: "d"}) == "s"
  end
end
