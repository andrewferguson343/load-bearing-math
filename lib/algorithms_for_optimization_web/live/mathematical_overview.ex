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
        line: %{color: "#e4002b"}
      }
    ]

    tangent_traces = [
      %{
        x: xs,
        y: ys,
        type: "scatter",
        mode: "lines",
        name: "Polynomial Graph",
        line: %{color: "#e4002b"}
      },
      %{
        x: xs,
        y: tangent_ys,
        type: "scatter",
        mode: "lines",
        name: "Tangent Line",
        line: %{color: "#1700e4"}
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

    socket =
      socket
      |> assign(page_title: "Mathematical Overview")
      |> assign(plot_data: Jason.encode!(plain_traces))
      |> assign(plot_layout: Jason.encode!(layout))
      |> assign(tangent_plot_data: Jason.encode!(tangent_traces))
      |> assign(tangent_plot_layout: Jason.encode!(tangent_layout))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active={:math} />

        <div class="r8-prose">
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

          <h2>Gradients</h2>
          <p>
            Optima are values in a function where a minimum value is found. There are local optima and global optima.
            A local optimum is lower than every nearby point, but there could be an even lower point elsewhere in the function.
            A global optimum is the single lowest point across the whole function. Take a look at the graph
            below: you can see two optima. The global optimum sits in quadrant 3, while the local optimum
            sits in quadrant 4.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
