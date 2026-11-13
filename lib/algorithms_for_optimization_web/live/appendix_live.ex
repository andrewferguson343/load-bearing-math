defmodule AlgorithmsForOptimizationWeb.AppendixLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Optimization Algorithms: Appendix")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:optimization} active_lesson={:appendix} />
        <div class="lbm-prose">
          <h1 id="page-heading">Appendix</h1>

          <h2 id="derivatives">Derivatives</h2>
          <p>The formal, limit-based definition of a derivative:</p>
          <p>{"$$f'(x) = \\lim_{\\Delta x \\to 0} \\frac{f(x + \\Delta x) - f(x)}{\\Delta x}$$"}</p>
          <p>
            This is the same "rate of change" idea from the Mathematical Overview page, just written
            precisely: it's the slope of the line through two points on the curve, $x$ and $x + \Delta x$,
            as that second point is pushed closer and closer to the first, until the gap $\Delta x$
            shrinks to zero and the line becomes tangent to the curve.
          </p>
          <p>
            Let's apply the derivative definition to our example equation, $f(x) = x^4 - 3x^2 + x$:
          </p>
          <p>
            {"$$f'(x) = \\lim_{\\Delta x \\to 0} \\frac{(x + \\Delta x)^4 - 3(x + \\Delta x)^2 + (x + \\Delta x) - (x^4 - 3x^2 + x)}{\\Delta x}$$"}
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
