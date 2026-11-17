defmodule AlgorithmsForOptimization.AnalyticsTest do
  use AlgorithmsForOptimization.DataCase, async: true

  alias AlgorithmsForOptimization.{Analytics, PageView, Repo}

  @today ~D[2026-11-17]

  defp views(path, referrer_host \\ "", day \\ @today) do
    case Repo.get_by(PageView, day: day, path: path, referrer_host: referrer_host) do
      nil -> 0
      row -> row.views
    end
  end

  describe "record/3" do
    test "counts repeat views of a page into one daily row" do
      for _ <- 1..3, do: assert(:ok = Analytics.record("/littles-law", "", @today))

      assert views("/littles-law") == 3
      assert Repo.aggregate(PageView, :count) == 1
    end

    test "keeps referrers and days apart" do
      Analytics.record("/littles-law", "news.ycombinator.com", @today)
      Analytics.record("/littles-law", "", @today)
      Analytics.record("/littles-law", "", Date.add(@today, -1))

      assert views("/littles-law", "news.ycombinator.com") == 1
      assert views("/littles-law") == 1
      assert views("/littles-law", "", Date.add(@today, -1)) == 1
    end

    test "rejects paths and hosts that can't be stored" do
      assert {:error, :invalid} = Analytics.record("no-leading-slash", "", @today)
      assert {:error, :invalid} = Analytics.record("/" <> String.duplicate("a", 300), "", @today)
      assert {:error, :invalid} = Analytics.record("/about", String.duplicate("a", 300), @today)
      assert {:error, :invalid} = Analytics.record(nil, "", @today)

      assert Repo.aggregate(PageView, :count) == 0
    end
  end

  describe "summary/3" do
    test "totals the window, fills empty days, and ranks pages and referrers" do
      for _ <- 1..3, do: Analytics.record("/littles-law", "news.ycombinator.com", @today)
      Analytics.record("/about", "", @today)
      Analytics.record("/about", "", Date.add(@today, -2))
      # Outside a 7-day window.
      Analytics.record("/about", "", Date.add(@today, -7))

      summary = Analytics.summary(7, 20, @today)

      assert summary.total == 5
      assert length(summary.by_day) == 7
      assert List.last(summary.by_day) == {@today, 4}
      assert {Date.add(@today, -1), 0} in summary.by_day
      assert summary.top_pages == [{"/littles-law", 3}, {"/about", 2}]
      assert summary.top_referrers == [{"news.ycombinator.com", 3}, {"", 2}]
    end

    test "is all zeros with no data" do
      summary = Analytics.summary(3, 20, @today)

      assert summary.total == 0
      assert Enum.map(summary.by_day, &elem(&1, 1)) == [0, 0, 0]
      assert summary.top_pages == []
    end
  end
end
