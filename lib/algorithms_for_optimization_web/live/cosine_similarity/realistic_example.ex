defmodule AlgorithmsForOptimizationWeb.CosineSimilarityRealisticExampleLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "A More Realistic Example")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:cosine_similarity} active_lesson={:realistic_example} />

        <div class="r8-prose">
          <h1 id="page-heading">A More Realistic Example</h1>
          <h2>There aren't just three dimensions</h2>
          <p>It's easy for us as humans to understand things that happen in two or three dimensions, but vectors in the real world can contain many, many dimensions.
            I was intentionally misleading us in the beginning. What's interesting is no matter how many dimensions or "traits" we choose, the math expands out to fit them.
            For example, the dot product for a three dimensional vector may be $\mathbf a \cdot \mathbf b = a_1 b_1 + a_2 b_2 + a_3 b_3$, but it actually expands out to
            n dimensions: {"$$a_1 b_1 + a_2 b_2 + a_3 b_3 + \\cdots + a_{n-1} b_{n-1} + a_n b_n$$"} neat, right?
           </p>
          <h2>A larger example</h2>
          <p>Using the exact same math from our simple video game vector example, we are going to scale this to 50 dimensions. Select a word from the list below
              and you'll get back the nearest neighbors using our similarity function!

              insert function call here
          </p>

          <p>All the training and inference that AI models use nowadays is exactly what we just walked through in these few pages, just an enormous
          amount of dot products across more data than we can imagine. No wonder GPU prices are so high.
          </p>
          <p>
            That's all I wanted to share, thanks for reading if you made it this far, or if you didn't. Please use the suggest a topic button up above
            for anything. There is no topic too small.
          </p>
          <p>
            You also got your first taste into an introduction of linear algbebra. See, it isn't that bad.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
