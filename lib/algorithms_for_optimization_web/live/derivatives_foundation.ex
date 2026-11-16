defmodule AlgorithmsForOptimizationWeb.DerivativesLive do
  @moduledoc """
  Foundation: Derivatives and Slope. A single-page primer that the Optimization series
  lists as a prerequisite. The curve and tangent line here are the same ones the
  series uses, so a reader who starts here sees familiar shapes later.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    # f(x) = x^4 - 3x^2 + x, with its tangent line at x = 1 (slope f'(1) = -1, so y = -x).
    xs = for x <- -220..220, do: x / 100.0
    ys = for x <- xs, do: x ** 4 - 3 * x ** 2 + x
    tangent_ys = for x <- xs, do: -x

    curve = %{
      x: xs,
      y: ys,
      type: "scatter",
      mode: "lines",
      name: "f(x)",
      line: %{color: "#14a394"}
    }

    tangent = %{
      x: xs,
      y: tangent_ys,
      type: "scatter",
      mode: "lines",
      name: "Tangent line at x = 1",
      line: %{color: "#e09a2b"}
    }

    curve_layout = %{
      title: %{text: "f(x) = x<sup>4</sup> - 3x<sup>2</sup> + x"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}},
      margin: %{t: 40}
    }

    tangent_layout = %{
      title: %{text: "The same curve with its tangent line at x = 1"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}, range: [-4, 4]},
      margin: %{t: 40}
    }

    socket =
      socket
      |> assign(page_title: "Derivatives and Slope")
      |> assign(curve_plot_data: Jason.encode!([curve]))
      |> assign(curve_plot_layout: Jason.encode!(curve_layout))
      |> assign(tangent_plot_data: Jason.encode!([curve, tangent]))
      |> assign(tangent_plot_layout: Jason.encode!(tangent_layout))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:overview} />
        <div class="lbm-prose">
          <h1 id="page-heading">Derivatives and Slope</h1>

          <%!-- TODO(andrew): intro. What a derivative measures and why anyone outside a
               calculus class would care: rate of change, "how fast is this moving right now". --%>
          <h2>Rate of change</h2>

          <p>
            A derivative is the rate of change of a function at a single point. Not the average
            change over some stretch, but how fast the function is changing right at $x$. Take a
            look at the curve below. It's steep in some places and flat in others, and the
            derivative is the number that says which, at any point you pick.
          </p>

          <div
            id="curve-chart"
            role="figure"
            aria-label="Chart: the curve f(x) = x⁴ − 3x² + x, which dips into two valleys with a hump between them."
            phx-hook="PlotlyChart"
            data-plotly-data={@curve_plot_data}
            data-plotly-layout={@curve_plot_layout}
            style="width: 100%; height: 400px;"
          >
          </div>

          <h2>The tangent line</h2>

          <p>
            The easiest way to see a derivative is to draw it. A tangent line touches the curve at
            exactly one point without crossing it there, and its slope is the derivative at that
            point. Below is the same curve with the tangent line drawn at $x = 1$.
          </p>

          <div
            id="tangent-line-chart"
            role="figure"
            aria-label="Chart: the curve f(x) = x⁴ − 3x² + x with its tangent line touching it at x = 1."
            phx-hook="PlotlyChart"
            data-plotly-data={@tangent_plot_data}
            data-plotly-layout={@tangent_plot_layout}
            style="width: 100%; height: 400px;"
          >
          </div>

          <.math_reveal id="the-tangent-line" label="How did we get this tangent line?">
            <h3>Finding a tangent line</h3>

            <p>For any differentiable function, the steps are the same:</p>

            <ul>
              <li>Take the derivative of the function</li>

              <li>Choose a point on the curve</li>

              <li>Plug the x value of the point into the derivative to get the slope</li>

              <li>Plug the x value of the point into the original equation to get the y value</li>

              <li>Plug into point-slope form</li>

              <li>Simplify</li>
            </ul>

            <h4>Worked example</h4>

            <p>Our function is $$f(x) = x^4 - 3x^2 + x$$</p>

            <p>Take the derivative: $$f'(x) = 4x^3 - 6x + 1$$</p>

            <p>
              Using $x = 1$ as the example point, plug 1 into both the original function and the
              derivative.
            </p>

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

          <%!-- TODO(andrew): the payoff section. Slope zero at the bottom of a valley (and the
               top of a hill), so "find the minimum" becomes "find where the derivative is zero".
               This is the hook the Optimization series hangs on. --%>
          <h2>Why slope zero matters</h2>

          <p>
            Look at the bottom of either valley in the curve. A tangent line drawn there would be
            perfectly flat: slope zero. The same is true at the top of the hump in the middle. So
            if you're hunting for the lowest point of a function, you're really hunting for the
            places where the derivative is zero. That one observation is the starting point for
            every optimization algorithm on this site.
          </p>

          <%!-- TODO(andrew): optional. The formal limit definition, or a link to it on the
               Optimization appendix (/appendix#derivatives) once that series is public. --%>
        </div>
      </div>
      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
