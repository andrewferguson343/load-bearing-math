defmodule AlgorithmsForOptimizationWeb.CosineSimilarityImplementationLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "A Simple Cosine Similarity Example")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:cosine_similarity} active_lesson={:implementation} />

        <div class="r8-prose">
          <h1 id="page-heading">A Simple Cosine Similarity Example</h1>
          <p>In computer land everything is denoted as vectors. LLMs we use every day train on an unfathomable amount of data to determine which
          words are the most common "neighbors" of search topics and can use this to created a weighted model. All of this data is stored as vectors
          in a database. I will not be doing this. Sorry.</p>
          <h2>Creating our vectors</h2>
          <p>
            For simplicity let's start with a very small example. Let's pick some words and assign some common traits to some of my favorite video games.
            Let's say we choose the traits <code>is_fps</code>, <code>has_campaign</code>, and <code>is_strategy</code>. Of course in the real world the are thousands
            of traits, if not more. We'll explore that later.
          </p>
          <ul>
            <li><code>Counter Strike = [1, 0, 0]</code></li>
            <li><code>Elden Ring = [0, 1, 0]</code></li>
            <li><code>Halo = [1, 1, 0]</code></li>
            <li><code>Stellaris = [0, 0, 1]</code></li>
            <li><code>Total War = [0, 1, 1]</code></li>
          </ul>
          <p>Recall from the overview that alternate form for the dot product:</p>
          <p>$$\mathbf a \cdot \mathbf b = \|\mathbf a\| \|\mathbf b\| \cos\theta$$</p>
          <p>
            we can rewrite this to solve for $\cos\theta$: {"$$\\cos\\theta = \\frac{\\mathbf a \\cdot \\mathbf b}{\\|\\mathbf a\\|\\|\\mathbf b\\|}$$"}
          </p>
          <p>
            We can then plug and play the values and see the similarities and differences. Let's look at Halo as our example. Halo is an FPS with a campaign mode.
            Let's compare this to Counter Strike, a team based FPS, and Stellaris, a Scifi strategy game. We see that between Halo and Counter Strike we get $\cos\theta = 1/\sqrt 2$. Between Halo and Stellaris however
            we see $\cos\theta = 0$. This shows us that Halo is more similar to Counter Strike than it is to Stellaris.
          </p>



          <.math_reveal id="dot-product-math" label="Check My Math">
          <p>Magnitude of the Halo vector: {"$$\\sqrt{1^2 + 1^2 + 0} = \\sqrt{2}$$"}</p>
          <p>Magnitude of the Counter Strike vector: {"$$\\sqrt{1^2 + 0 + 0} = 1$$"}</p>
          <p>Magnitude of the Stellaris vector: {"$$\\sqrt{0 + 0 + 1^2} = 1$$"}</p>
          <p>Dot product of the Halo and Counter Strike vectors:</p>
          <p>$$1\cdot 1 + 1\cdot 0 + 0\cdot 0 = 1$$</p>
          <p>Dot product of the Halo and Stellaris vectors:</p>
          <p>$$1\cdot 0 + 1\cdot 0 + 0\cdot 1 = 0$$</p>

          <p>Now we have everything we need to plug into the main formula $\cos\theta$: {"$$\\cos\\theta = \\frac{\\mathbf a \\cdot \\mathbf b}{\\|\\mathbf a\\|\\|\\mathbf b\\|}$$"}</p>
          <p>Halo vs Counter Strike: {"$$\\frac{1}{\\sqrt 2 \\cdot 1} = \\frac{1}{\\sqrt 2}$$"}</p>
          <p>Halo vs Stellaris: {"$$\\frac{0}{\\sqrt 2 \\cdot 1} = 0$$"}</p>
          </.math_reveal>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
