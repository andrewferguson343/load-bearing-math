defmodule AlgorithmsForOptimizationWeb.MathematicsLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    xs = for x <- -220..220, do: x / 100.0
    ys = for x <- xs, do: x**4 - 3*x**2 + x

    traces = [
      %{
        x: xs,
        y: ys,
        type: "scatter",
        mode: "lines",
        name: "Polynomial Graph",
        line: %{color: "#e4002b"}
      }
    ]

    layout = %{
      title: %{text: "Graph of f(x) = x<sup>4</sup> - 3x<sup>2</sup> + x"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}},
      margin: %{t: 40}
    }

    socket =
      socket
      |> assign(page_title: "Mathematical Overview")
      |> assign(plot_data: Jason.encode!(traces))
      |> assign(plot_layout: Jason.encode!(layout))

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
            Optima are values in a function where a minimum value is found. There are local optima and global optima.
            A local optimum is lower than every nearby point, but there could be an even lower point elsewhere in the function.
            A global optimum is the single lowest point across the whole function. Take a look at the graph
            below: you can see two optima. The global optimum sits in quadrant 3, while the local optimum
            sits in quadrant 4.
          </p>
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
