defmodule AlgorithmsForOptimizationWeb.EulersMethodPagesTest do
  use AlgorithmsForOptimizationWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # Follows the `public_topics` gate like the other topic tests.
  if Topics.public?(:eulers_method) do
    test "renders every lesson, with the end note on the last one only", %{conn: conn} do
      for path <- [
            ~p"/eulers-method",
            ~p"/eulers-method-stepping",
            ~p"/eulers-method-error",
            ~p"/eulers-method-stability"
          ] do
        {:ok, view, _html} = live(conn, path)

        assert has_element?(view, "#page-heading")
        refute has_element?(view, "#topic-end-note")
      end

      {:ok, view, _html} = live(conn, ~p"/eulers-method-better-steppers")
      assert has_element?(view, "#topic-end-note")
    end
  else
    test "redirects home while gated", %{conn: conn} do
      for path <- [
            ~p"/eulers-method",
            ~p"/eulers-method-stepping",
            ~p"/eulers-method-error",
            ~p"/eulers-method-stability",
            ~p"/eulers-method-better-steppers"
          ] do
        assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, path)
      end
    end
  end

  test "registers one lesson per route" do
    paths = Topics.fetch!(:eulers_method).lessons |> Enum.map(& &1.path)
    assert length(paths) == 5
    assert Topics.fetch!(:eulers_method).prerequisites == [:derivatives]
  end
end
