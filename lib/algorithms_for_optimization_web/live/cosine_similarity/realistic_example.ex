defmodule AlgorithmsForOptimizationWeb.CosineSimilarityRealisticExampleLive do
  use AlgorithmsForOptimizationWeb, :live_view

  @cosine_similarity_source_path Path.expand(
                                   "../../../algorithms_for_optimization/cosine_similarity.ex",
                                   __DIR__
                                 )
  @external_resource @cosine_similarity_source_path
  @cosine_similarity_source File.read!(@cosine_similarity_source_path)

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Cosine Similarity: A More Realistic Example")
      |> assign(words: AlgorithmsForOptimization.WordVectors.words() |> Enum.sort())
      |> assign(selected_word: nil)
      |> assign(neighbors: [])
      |> assign(cosine_similarity_source: @cosine_similarity_source)

    {:ok, socket}
  end

  def handle_event("select_word", %{"word" => ""}, socket) do
    {:noreply, assign(socket, selected_word: nil, neighbors: [])}
  end

  def handle_event("select_word", %{"word" => word}, socket) do
    target_vector = AlgorithmsForOptimization.WordVectors.vector(word)

    neighbors =
      AlgorithmsForOptimization.WordVectors.words()
      |> Enum.reject(&(&1 == word))
      |> Enum.map(fn other ->
        score =
          AlgorithmsForOptimization.CosineSimilarity.cosine_similarity(
            target_vector,
            AlgorithmsForOptimization.WordVectors.vector(other)
          )

        {other, score}
      end)
      |> Enum.sort_by(fn {_word, score} -> score end, :desc)
      |> Enum.take(5)

    {:noreply, assign(socket, selected_word: word, neighbors: neighbors)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:cosine_similarity} active_lesson={:realistic_example} />

        <div class="lbm-prose">
          <h1 id="page-heading">A More Realistic Example</h1>
          <h2>There aren't just three dimensions</h2>
          <p>
            It's easy for us as humans to understand things that happen in two or three dimensions, but vectors in the real world can contain many, many dimensions.
            I was intentionally misleading us in the beginning. What's interesting is no matter how many dimensions or "traits" we choose, the math expands out to fit them.
            For example, the dot product for a three dimensional vector may be $\mathbf a \cdot \mathbf b = a_1 b_1 + a_2 b_2 + a_3 b_3$, but it actually expands out to
            n dimensions: {"$$a_1 b_1 + a_2 b_2 + a_3 b_3 + \\cdots + a_{n-1} b_{n-1} + a_n b_n$$"} neat, right?
          </p>
          <h2>A larger example</h2>
          <p>
            Using the exact same math from our simple video game vector example, we are going to scale this to 50 dimensions. Select a word from the list below
            and you'll get back the nearest neighbors using our similarity function!
          </p>
          <div class="lbm-demo">
            <h3>Try it</h3>
            <p>Pick a word and see which other words are its nearest neighbors.</p>

            <form phx-change="select_word" class="lbm-demo-form">
              <.input
                type="select"
                name="word"
                label="Word"
                options={@words}
                prompt="Choose a word..."
                value={@selected_word}
              />
            </form>

            <ul :if={@neighbors != []} class="list bg-base-200 rounded-box shadow-sm mt-4">
              <li :for={{word, score} <- @neighbors} class="list-row items-center">
                <div class="text-base font-semibold">{word}</div>
                <div class="flex items-center gap-3 ml-auto">
                  <span class="text-sm opacity-70 font-mono">{Float.round(score, 3)}</span>
                </div>
              </li>
            </ul>

            <.math_reveal id="cosine-similarity-code" label="Show the Code">
              <h3>The Elixir Implementation</h3>
              <p>
                This is the exact code powering the demo above, dot product, magnitude, and cosine similarity.
              </p>
              <pre class="lbm-code-block"><code>{@cosine_similarity_source}</code></pre>
            </.math_reveal>
          </div>
          <p>Here is an example of what "king" looks like with our example embeddings:</p>
          <code>"king" => [0.50451, 0.68607, -0.59517, -0.022801, 0.60046, -0.13498, -0.08813, 0.47377, -0.61798, -0.31012, -0.076666, 1.493, -0.034189, -0.98173, 0.68229, 0.81722, -0.51874, -0.31503, -0.55809, 0.66421, 0.1961, -0.13495, -0.11476, -0.30344, 0.41177, -2.223, -1.0756, -1.0783, -0.34354, 0.33505, 1.9927, -0.04234, -0.64319, 0.71125, 0.49159, 0.16754, 0.34344, -0.25663, -0.8523, 0.1661, 0.40102, 1.1685, -1.0137, -0.21585, -0.15155, 0.78321, -0.91241, -1.6106, -0.64426, -0.51042]</code>
          <p>And that's still nowhere close to what an actual vector would look like!</p>

          <p>
            All the training and inference that AI models use nowadays is exactly what we just walked through in these few pages, just an enormous
            amount of dot products across more data than we can imagine. No wonder GPU prices are so high.
          </p>
          <p>
            That's all I wanted to share, thanks for reading if you made it this far, or if you didn't. Please use the suggest a topic button up above
            for anything. There is no topic too small.
          </p>
          <p>
            You also got your first taste of linear algebra. See, it isn't that bad.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
