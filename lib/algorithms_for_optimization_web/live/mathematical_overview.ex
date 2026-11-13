defmodule AlgorithmsForOptimizationWeb.MathematicsLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    xs = for x <- -220..220, do: x / 100.0
    ys = for x <- xs, do: x**4 - 3*x**2 + x
    tangent_ys = for x <- xs, do: -x

    plain_traces = [
      %{
        x: xs,
        y: ys,
        type: "scatter",
        mode: "lines",
        name: "Polynomial Graph",
        line: %{color: "#14a394"}
      }
    ]

    tangent_traces = [
      %{
        x: xs,
        y: ys,
        type: "scatter",
        mode: "lines",
        name: "Polynomial Graph",
        line: %{color: "#14a394"}
      },
      %{
        x: xs,
        y: tangent_ys,
        type: "scatter",
        mode: "lines",
        name: "Tangent Line",
        line: %{color: "#e09a2b"}
      }
    ]

    layout = %{
      title: %{text: "Graph of f(x) = x<sup>4</sup> - 3x<sup>2</sup> + x"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}},
      margin: %{t: 40}
    }

    tangent_layout = %{
      title: %{text: "f(x) = x<sup>4</sup> - 3x<sup>2</sup> + x with Tangent Line at x=1"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}},
      margin: %{t: 40}
    }

    # 2-variable surface f(x, y) = x^2 + y^2, with its tangent hyperplane at
    # the point (1, 1). Gradient there: grad f = (2x, 2y) = (2, 2), giving
    # tangent plane: z = f(1,1) + 2(x - 1) + 2(y - 1) = 2x + 2y - 2.
    surface_xs = for x <- -200..200//10, do: x / 100.0
    surface_ys = for y <- -200..200//10, do: y / 100.0
    surface_z = for y <- surface_ys, do: for(x <- surface_xs, do: x * x + y * y)

    plane_xs = for x <- 0..200//20, do: x / 100.0
    plane_ys = for y <- 0..200//20, do: y / 100.0
    plane_z = for y <- plane_ys, do: for(x <- plane_xs, do: 2 * x + 2 * y - 2)

    gradient_traces = [
      %{
        type: "surface",
        x: surface_xs,
        y: surface_ys,
        z: surface_z,
        colorscale: "Reds",
        opacity: 0.85,
        showscale: false,
        name: "f(x, y) = x^2 + y^2"
      },
      %{
        type: "surface",
        x: plane_xs,
        y: plane_ys,
        z: plane_z,
        colorscale: [[0, "#e09a2b"], [1, "#e09a2b"]],
        opacity: 0.55,
        showscale: false,
        name: "Tangent Hyperplane"
      }
    ]

    gradient_layout = %{
      title: %{
        text:
          "f(x, y) = x<sup>2</sup> + y<sup>2</sup> with Tangent Hyperplane at (1, 1)"
      },
      scene: %{
        xaxis: %{title: %{text: "x"}},
        yaxis: %{title: %{text: "y"}},
        zaxis: %{title: %{text: "f(x, y)"}}
      },
      margin: %{t: 60}
    }

    socket =
      socket
      |> assign(page_title: "Mathematical Overview")
      |> assign(plot_data: Jason.encode!(plain_traces))
      |> assign(plot_layout: Jason.encode!(layout))
      |> assign(tangent_plot_data: Jason.encode!(tangent_traces))
      |> assign(tangent_plot_layout: Jason.encode!(tangent_layout))
      |> assign(gradient_plot_data: Jason.encode!(gradient_traces))
      |> assign(gradient_plot_layout: Jason.encode!(gradient_layout))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="c8-lesson">
        <Layouts.lesson_toc active_topic={:optimization} active_lesson={:math} />

        <div class="c8-prose">
          <h1 id="page-heading">A Mathematical Overview</h1>
          <h2>Mathematical Topics</h2>
          <p>
            Yes, I'm sorry. Everybody hates math. It's boring, it takes a long time to do right, and it's
            generally confusing to look at. However, the optimization models underneath all of this are
            built on a handful of core mathematical concepts, and I'll do my best to explain them as
            simply as possible. Here are the brief topics we'll cover.
          </p>
          <ul>
            <li>Objective functions</li>
            <li>Optima</li>
            <li>Derivatives and Slope</li>
            <li>Gradients</li>
            <li>Brief whatever else I feel like adding</li>
          </ul>

          <h2>Objective functions</h2>
          <p>
            We can think of an objective function as some function that we want to minimize. It's denoted
            f(<b>x</b>), where <b>x</b> is a set of variables, and the goal is to find the specific values
            for those variables that minimize it.
          </p>

          <h2>Optima</h2>
          <p>
            Optima are values in a function where a minimum value is found. There are local optima and global optima.
            A local optimum is lower than every nearby point, but there could be an even lower point elsewhere in the function.
            A global optimum is the single lowest point across the whole function. Take a look at the graph
            below: you can see two optima. The global optimum sits in quadrant 3, while the local optimum
            sits in quadrant 4.
          </p>
          <div
            id="objective-function-chart"
            phx-hook="PlotlyChart"
            data-plotly-data={@plot_data}
            data-plotly-layout={@plot_layout}
            style="width: 100%; height: 400px;"
          >
          </div>
          <h2>Derivatives and Slope</h2>
          <p>
            Finding the minima of a function depends heavily on differentiation. We can think of the derivative
            of a function as the rate of change of the function at a certain point $x$. We can visualize this by
            drawing a tangent line to the plot of a function, which is a line that touches the curve at
            one specific point, but does not cross at that point. Take a look at the graph below: it shows the same curve with a tangent line drawn at x = 1.
          </p>
           <.math_reveal id="the-tangent-line" label="How did we get this tangent line?">
            <h3>The Tangent Line</h3>
            <p>For any differentiable function, there are steps to find the tangent line:</p>
            <ul>
              <li>Take the derivative of the function</li>
              <li>Choose a point on the curve</li>
              <li>Plug the x value of the point into the derivative to get the slope</li>
              <li>Plug the x value of the point into the original equation to get the y value</li>
              <li>Plug into point-slope form</li>
              <li>Simplify</li>
            </ul>

            <h4>Worked example</h4>
            <p>Our original equation is $$f(x) = x^4 - 3x^2 + x$$</p>
            <p>Take the derivative (see Appendix A for the worked derivative): $$f'(x) = 4x^3 - 6x + 1$$</p>
            <p>Since I chose 1 as my example point, plug 1 into both the original equation and the derivative.</p>
            <p>
              $$f(1) = 1^4 - 3(1)^2 + 1$$
              $$f(1) = 1 - 3 + 1$$
              $$f(1) = -1$$
            </p>
            <p>
              $$f'(1) = 4(1)^3 - 6(1) + 1$$
              $$f'(1) = 4 - 6 + 1$$
              $$f'(1) = -1$$
            </p>
            <p>Plug the values into point-slope form for a line, $y - y_1 = m(x - x_1)$:</p>
            <p>$$y - (-1) = -1(x - 1)$$</p>
            <p>Which simplifies to $y = -x$, tangent to the curve at the point $(1, -1)$.</p>
          </.math_reveal>
          <div
            id="tangent-line-chart"
            phx-hook="PlotlyChart"
            data-plotly-data={@tangent_plot_data}
            data-plotly-layout={@tangent_plot_layout}
            style="width: 100%; height: 400px;"
          >
          </div>
          <p>
            So what does this all mean? In short, when we are trying to find the minimum of a function, the slope of the tangent line at the
            point we are testing must be 0. That tells us the point is a critical point, a candidate for a local minimum, but a zero slope alone
            doesn't guarantee one, the same test also flags local maximums. That's only part of the problem, then. We have to check a point some
            distance $\Delta$ away from it in each direction to make sure the function is decreasing toward our point from both sides, that's
            what actually confirms it's a local minimum.
          </p>

          <h2>Gradients</h2>
          <p>
            Gradients are how we represent derivatives in equations of more than one variable. The gradient at a point, combined with the function's
            value there, gives us a tangent hyperplane to the function at that point. The gradient of a multivariate function is a vector made up
            of the partial derivative with respect to each variable. I know the graph is kind of hard to see, but you can visualize the general idea.
          </p>
          <div
            id="gradient-hyperplane-chart"
            phx-hook="PlotlyChart"
            data-plotly-data={@gradient_plot_data}
            data-plotly-layout={@gradient_plot_layout}
            style="width: 100%; height: 500px;"
          >
          </div>
          <.math_reveal id="partial-derivative-math" label="Partial Derivatives?">
            <h3>A Partial Derivative</h3>
            <p>
              A derivative is always taken with respect to a variable. When there are multiple variables and we
              want to take the derivative with respect to one of them, it is called a partial derivative of the
              multivariate function.
            </p>
            <p>
              For the plotted function $f(x, y) = x^2 + y^2$, if we wanted to take the partial derivative with
              respect to $x$, we would treat any expression containing just $y$ as a constant.
            </p>
            <p>The partial derivative of $f(x, y) = x^2 + y^2$ with respect to $x$ is:</p>
            <p>{"$$\\frac{\\partial f}{\\partial x} = 2x$$"}</p>
          </.math_reveal>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
