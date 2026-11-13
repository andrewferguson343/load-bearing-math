defmodule AlgorithmsForOptimizationWeb.MathematicsOverviewTest do
  use AlgorithmsForOptimizationWeb.ConnCase
  import Phoenix.LiveViewTest

  alias AlgorithmsForOptimization.Topics

  # The Optimization series is gated by `public_topics` in config. This test follows that
  # setting, so it keeps passing (and keeps checking the right thing) when the topic goes public.
  if Topics.public?(:optimization) do
    test "renders the overview page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/overview")
      assert html =~ "Overview"
    end
  else
    test "redirects home while the Optimization topic isn't public", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: "/"}}} = live(conn, ~p"/overview")
    end
  end
end
