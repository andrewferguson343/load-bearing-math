defmodule AlgorithmsForOptimizationWeb.PageController do
  use AlgorithmsForOptimizationWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def topics(conn, _params) do
    render(conn, :topics, topics: AlgorithmsForOptimization.Topics.visible())
  end
end
