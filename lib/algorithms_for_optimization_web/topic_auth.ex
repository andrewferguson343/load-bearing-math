defmodule AlgorithmsForOptimizationWeb.TopicAuth do
  @moduledoc """
  Gates each topic's LiveViews behind `Topics.public?/1`, and fills in the
  SEO metadata (description + lesson structured data) for the page being viewed.
  """
  import Phoenix.LiveView
  import Phoenix.Component, only: [assign: 3]

  alias AlgorithmsForOptimization.Topics

  def on_mount(topic_id, _params, _session, socket) do
    if Topics.public?(topic_id) do
      topic = Topics.fetch!(topic_id)

      {:cont,
       attach_hook(socket, :topic_seo, :handle_params, fn _params, uri, socket ->
         path = URI.parse(uri).path
         lesson = Enum.find(topic.lessons, &(&1.path == path))

         socket =
           socket
           |> assign(:page_description, (lesson && lesson[:description]) || topic.description)
           |> assign(:seo_lesson, lesson && %{topic: topic, lesson: lesson})

         {:cont, socket}
       end)}
    else
      {:halt, push_navigate(socket, to: "/")}
    end
  end
end
