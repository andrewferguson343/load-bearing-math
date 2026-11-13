defmodule AlgorithmsForOptimizationWeb.PageController do
  use AlgorithmsForOptimizationWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def topics(conn, _params) do
    render(conn, :topics,
      topics: AlgorithmsForOptimization.Topics.visible(),
      page_title: "Topics",
      page_description:
        "Every Load Bearing Math series in one place, each one a short, hands-on walkthrough of the math behind everyday engineering."
    )
  end
end
