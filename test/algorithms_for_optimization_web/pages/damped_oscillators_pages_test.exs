defmodule AlgorithmsForOptimizationWeb.DampedOscillatorsPagesTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests.
  if Topics.public?(:damped_oscillators) do
    test "renders every lesson, with the end note on the last one only", %{conn: conn} do
      for path <- [
            ~p"/damped-oscillators",
            ~p"/damped-oscillators-model",
            ~p"/damped-oscillators-three-cases",
            ~p"/damped-oscillators-phase-plane"
          ] do
        {:ok, view, _html} = live(conn, path)

        assert has_element?(view, "#page-heading")
        refute has_element?(view, "#topic-end-note")
      end

      {:ok, view, _html} = live(conn, ~p"/damped-oscillators-tuning")
      assert has_element?(view, "#topic-end-note")
    end
  else
    test "redirects home while gated", %{conn: conn} do
      for path <- [
            ~p"/damped-oscillators",
            ~p"/damped-oscillators-model",
            ~p"/damped-oscillators-three-cases",
            ~p"/damped-oscillators-phase-plane",
            ~p"/damped-oscillators-tuning"
          ] do
        assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, path)
      end
    end
  end

  test "registers one lesson per route" do
    paths = Topics.fetch!(:damped_oscillators).lessons |> Enum.map(& &1.path)
    assert length(paths) == 5
    assert Topics.fetch!(:damped_oscillators).prerequisites == [:derivatives, :eigenvalues]
  end
end
