defmodule AlgorithmsForOptimizationWeb.TopicEndNoteTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  # Cosine Similarity is public and has several parts: the end note belongs on the last
  # one only. The Leaky Bucket is a single public page, so it gets the note too.
  test "shows the end note on a topic's last page only", %{conn: conn} do
    {:ok, last, _html} = live(conn, ~p"/cosine-similarity-realistic-example")
    assert has_element?(last, ~s(#end-note-work[href="/work-with-me"]))

    for path <- [~p"/cosine-similarity", ~p"/cosine-similarity-math"] do
      {:ok, view, _html} = live(conn, path)
      refute has_element?(view, "#topic-end-note")
    end
  end

  test "single-page topics show it", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/leaky-bucket")
    assert has_element?(view, "#topic-end-note")
  end
end
