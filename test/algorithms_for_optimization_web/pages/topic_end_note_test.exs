defmodule AlgorithmsForOptimizationWeb.TopicEndNoteTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  # Cosine Similarity is public and has several parts: the end note belongs on the last
  # one only. The Leaky Bucket is a single page, so it gets the note too (checked while public).
  test "shows the end note on a topic's last page only", %{conn: conn} do
    {:ok, last, _html} = live(conn, ~p"/cosine-similarity-realistic-example")
    assert has_element?(last, ~s(#end-note-work[href="/work-with-me"]))

    for path <- [~p"/cosine-similarity", ~p"/cosine-similarity-math"] do
      {:ok, view, _html} = live(conn, path)
      refute has_element?(view, "#topic-end-note")
    end
  end

  # Follows the `public_topics` gate: gated topics redirect home instead of rendering.
  if AlgorithmsForOptimization.Topics.public?(:leaky_bucket) do
    test "single-page topics show it", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/leaky-bucket")
      assert has_element?(view, "#topic-end-note")
    end
  end
end
