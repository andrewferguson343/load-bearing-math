defmodule AlgorithmsForOptimizationWeb.EigenvaluesPagesTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests.
  if Topics.public?(:eigenvalues) do
    test "renders every lesson, with the end note on the last one only", %{conn: conn} do
      for path <- [
            ~p"/eigenvalues",
            ~p"/eigenvalues-basics"
          ] do
        {:ok, view, _html} = live(conn, path)

        assert has_element?(view, "#page-heading")
        refute has_element?(view, "#topic-end-note")
      end

      {:ok, view, _html} = live(conn, ~p"/eigenvalues-stability")
      assert has_element?(view, "#topic-end-note")
    end
  else
    test "redirects home while gated", %{conn: conn} do
      for path <- [
            ~p"/eigenvalues",
            ~p"/eigenvalues-basics",
            ~p"/eigenvalues-stability"
          ] do
        assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, path)
      end
    end
  end

  test "registers one lesson per route" do
    paths = Topics.fetch!(:eigenvalues).lessons |> Enum.map(& &1.path)
    assert length(paths) == 3
    assert %{kind: :foundation, collection: :foundations} = Topics.fetch!(:eigenvalues)
  end
end
