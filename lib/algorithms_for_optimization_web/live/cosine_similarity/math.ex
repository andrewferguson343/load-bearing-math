defmodule AlgorithmsForOptimizationWeb.CosineSimilarityMathLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    vector_traces = [
      %{
        x: [1],
        y: [1],
        type: "scatter",
        mode: "markers+text",
        text: ["⟨1, 1⟩"],
        textposition: "top right",
        marker: %{color: "#14a394", size: 8},
        showlegend: false
      }
    ]

    vector_layout = %{
      title: %{text: "The Vector ⟨1, 1⟩"},
      xaxis: %{title: %{text: "x"}, range: [-0.5, 2], zeroline: true, zerolinewidth: 2},
      yaxis: %{
        title: %{text: "y"},
        range: [-0.5, 2],
        zeroline: true,
        zerolinewidth: 2,
        scaleanchor: "x",
        scaleratio: 1
      },
      annotations: [
        %{
          x: 1,
          y: 1,
          ax: 0,
          ay: 0,
          axref: "x",
          ayref: "y",
          showarrow: true,
          arrowhead: 3,
          arrowsize: 1.5,
          arrowwidth: 2,
          arrowcolor: "#e09a2b"
        }
      ],
      margin: %{t: 40}
    }

    vector_3d_traces = [
      %{
        x: [0, 1],
        y: [0, 2],
        z: [0, 3],
        type: "scatter3d",
        mode: "lines+markers+text",
        text: ["", "⟨1, 2, 3⟩"],
        textposition: "top right",
        line: %{color: "#e09a2b", width: 6},
        marker: %{color: "#14a394", size: 4},
        showlegend: false
      }
    ]

    vector_3d_layout = %{
      title: %{text: "The Vector ⟨1, 2, 3⟩"},
      scene: %{
        xaxis: %{title: %{text: "x"}, range: [0, 3]},
        yaxis: %{title: %{text: "y"}, range: [0, 3]},
        zaxis: %{title: %{text: "z"}, range: [0, 3]}
      },
      margin: %{t: 40}
    }

    socket =
      socket
      |> assign(page_title: "Cosine Similarity: An Introduction to the Math")
      |> assign(vector_plot_data: Jason.encode!(vector_traces))
      |> assign(vector_plot_layout: Jason.encode!(vector_layout))
      |> assign(vector_3d_plot_data: Jason.encode!(vector_3d_traces))
      |> assign(vector_3d_plot_layout: Jason.encode!(vector_3d_layout))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:cosine_similarity} active_lesson={:math} />

        <div class="lbm-prose">
          <h1 id="page-heading">An Introduction to the Math</h1>

          <h2>An Introduction to Vectors</h2>

          <p>Determining cosine similarity has everything to do with the concept of vectors. A vector is simply a quantity that has both a
          magnitude and direction. There are two standard notations for vectors: we can write a vector as $\langle 1, 1 \rangle$ or as $1\mathbf i + 1\mathbf j$. Both of these mean the same thing
          and can be plotted on a graph similarly to cartesian coordinates.
          </p>
          <div
            id="vector-chart"
            phx-hook="PlotlyChart"
            data-plotly-data={@vector_plot_data}
            data-plotly-layout={@vector_plot_layout}
            style="width: 100%; height: 400px;"
          >
          </div>

          <p>
            We can expand this definition to 3 dimensions by adding a third orthogonal line to our plane. Unlike regular 2d cartesian coordinates which are known as
            ordered pairs in the (x,y) format, 3 dimensions uses the (x,y,z) format. In vector land we denote these as $\langle 1, 2, 3 \rangle$, or $1\mathbf i + 2\mathbf j + 3\mathbf k$.
          </p>
          <div
            id="vector-3d-chart"
            phx-hook="PlotlyChart"
            data-plotly-data={@vector_3d_plot_data}
            data-plotly-layout={@vector_3d_plot_layout}
            style="width: 100%; height: 500px;"
          >
          </div>

          <h2>The Magnitude of a vector</h2>
          <p>
            If we have a vector $\mathbf a = \langle a_1, a_2, a_3 \rangle$, we can find its magnitude by applying the following formula:
          </p>
          <p>{"$$\\sqrt{a_1^2 + a_2^2 + a_3^2}$$"}</p>
          <p>This is denoted as $\|\mathbf a\|$.</p>

          <p>Cool, so now we know the basics of vectors, now just one last thing.</p>

          <h2>The Dot Product</h2>
          <p>The Dot Product is a technique used to find the product of two vectors. The output of the dot product is always a real number. Vectors go in, one number comes out.
          The formal definition for the product of two vectors $\mathbf a$ and $\mathbf b$ in two dimensional space is $a_1 b_1 + a_2 b_2$. If we want to take the dot product of a vector
          in three dimensional space we simply add the third component of the vector into the equation, making $a_1 b_1 + a_2 b_2 + a_3 b_3$.
          </p>

          <h2>The <i>other</i> Dot Product</h2>
          <p>
            But Andrew, this is about cosine similarity! Where is the trigonometry? Where is the cosine? Yes, there is another kinda worse form of the Dot Product.
          </p>
          <p>$$\mathbf a \cdot \mathbf b = \|\mathbf a\| \|\mathbf b\| \cos\theta$$</p>
          <p>As you can probably guess, this form is what we will spend our time working with.</p>

          <h2>That's all the background info. Let's get started...</h2>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
