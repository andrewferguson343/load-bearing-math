defmodule AlgorithmsForOptimizationWeb.TopicAuth do
  import Phoenix.LiveView

  def on_mount(topic_id, _params, _session, socket) do
    if AlgorithmsForOptimization.Topics.public?(topic_id) do
      {:cont, socket}
    else
      {:halt, push_navigate(socket, to: "/")}
    end
  end
end
