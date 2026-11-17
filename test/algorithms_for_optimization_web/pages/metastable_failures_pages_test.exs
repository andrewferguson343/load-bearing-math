defmodule AlgorithmsForOptimizationWeb.MetastableFailuresPagesTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests.
  if Topics.public?(:metastable_failures) do
    test "renders every lesson, with the end note on the last one only", %{conn: conn} do
      for path <- [
            ~p"/metastable-failures",
            ~p"/metastable-failures-anatomy",
            ~p"/metastable-failures-queues",
            ~p"/metastable-failures-feedback",
            ~p"/metastable-failures-phase-plane",
            ~p"/metastable-failures-basins"
          ] do
        {:ok, view, _html} = live(conn, path)

        assert has_element?(view, "#page-heading")
        refute has_element?(view, "#topic-end-note")
      end

      {:ok, view, _html} = live(conn, ~p"/metastable-failures-recovery")
      assert has_element?(view, "#topic-end-note")
    end
  else
    test "redirects home while gated", %{conn: conn} do
      for path <- [
            ~p"/metastable-failures",
            ~p"/metastable-failures-anatomy",
            ~p"/metastable-failures-queues",
            ~p"/metastable-failures-feedback",
            ~p"/metastable-failures-phase-plane",
            ~p"/metastable-failures-basins",
            ~p"/metastable-failures-recovery"
          ] do
        assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, path)
      end
    end
  end

  test "registers one lesson per route" do
    paths = Topics.fetch!(:metastable_failures).lessons |> Enum.map(& &1.path)
    assert length(paths) == 7
    assert Topics.fetch!(:metastable_failures).prerequisites == [:derivatives, :eigenvalues]
  end
end
