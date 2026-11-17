defmodule AlgorithmsForOptimizationWeb.DerivativesSlopeLive do
  @moduledoc """
  Foundation: Derivatives and Slope, lesson 01 of the primer the Optimization series
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
        <Layouts.lesson_toc active_topic={:derivatives} active_lesson={:slope} />
        <div class="lbm-prose">
          <h1 id="page-heading">Derivatives and Slope</h1>

          <%!-- Outline only. Every heading and TODO below is a placeholder for Andrew to write;
               the charts are wired and ready. Keep or rename sections freely. --%>

          <%!-- TODO(andrew) 1. The one-sentence version, with a reason to care.
               "How fast something is changing right now." Lead with an engineering example
               (a request counter is a function of time; requests per second is its derivative)
               rather than a curve. --%>
          <h2>What a derivative measures</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 2. Average rate vs instantaneous rate. Slope between two points on
               the curve, then slide the second point closer. Sets up the limit idea without
               the formal definition. The curve below is the one the Optimization series uses. --%>
          <h2>Average rate vs. rate right now</h2>
          <p>TODO</p>

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

          <%!-- TODO(andrew) 3. The tangent line picture. What "touches at one point" means and
               why its slope is the derivative there. Chart shows the tangent at x = 1. --%>
          <h2>The tangent line</h2>
          <p>TODO</p>

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

          <%!-- Worked example lifted verbatim from your Optimization "A Mathematical Overview"
               page (the tangent-line reveal). Keep, trim, or rewrite. --%>
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

          <%!-- TODO(andrew) 4. How to actually take one. Power rule, constant rule, sum rule,
               worked on this page's own function so f'(x) = 4x³ − 6x + 1 isn't a magic reveal.
               Name the chain rule only ("the one you need when functions nest"); it lives in
               the appendix. --%>
          <h2>Taking a derivative</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 5. Reading the sign. Positive = climbing, negative = falling,
               zero = flat. Valley bottoms and hilltops have slope zero: the hook the
               Optimization series hangs on ("find the minimum" becomes "find where f' = 0"). --%>
          <h2>Reading the sign</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 6. One worked engineering example with units. Candidates: disk
               usage over time → slope → remaining space / slope = runway; or queue depth.
               One small table of numbers, one slope, one answer. If you want a chart for it,
               say what the data is and I'll wire the plot. --%>
          <h2>A worked example with units</h2>
          <p>TODO</p>

          <%!-- TODO(andrew) 7. Where it goes next: gradients for several variables
               (Optimization series), differential equations when the rate itself is the model
               (Leaky Bucket, Damped Oscillators), Euler's method for stepping forward when you
               can't solve exactly. One sentence each. Links only once those topics are public.
               Optional: the formal limit definition in a reveal, or a link to
               /appendix#derivatives when the Optimization series ships. --%>
          <h2>Where this goes next</h2>
          <p>TODO</p>
        </div>
      </div>

      <Layouts.topic_end_note active_topic={:derivatives} active_lesson={:slope} />
    </Layouts.app>
    """
  end
end
