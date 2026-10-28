defmodule AlgorithmsForOptimizationWeb.PageController do
  use AlgorithmsForOptimizationWeb, :controller

  def home(conn, _params) do
    render(conn, :home, topics: AlgorithmsForOptimization.Topics.visible())
  end
end
