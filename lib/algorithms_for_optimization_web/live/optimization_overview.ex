defmodule AlgorithmsForOptimizationWeb.OptimizationLive do
  use AlgorithmsForOptimizationWeb, :live_view
  alias AlgorithmsForOptimization.SimpleBracketing
  @bracketing_source File.read!(Path.join(__DIR__, "../../algorithms_for_optimization/simple_bracketing.ex"))
                    |> String.trim()

  @plot_xs for x <- -1000..1000, do: x / 100.0

  @default_function "parabola"

  defp functions do
    %{
      "parabola" => {"(x - 2)²", fn x -> (x - 2) ** 2 end},
      "shifted" => {"(x + 3)²", fn x -> (x + 3) ** 2 end}
    }
  end

  defp plot_assigns(key, bracket \\ nil) do
    {label, f} = Map.fetch!(functions(), key)
    ys = Enum.map(@plot_xs, f)

    data = [
      %{
        x: @plot_xs,
        y: ys,
        type: "scatter",
        mode: "lines",
        name: label,
        line: %{color: "#e4002b"}
      }
    ]

    layout = %{
      title: %{text: "f(x) = #{label}"},
      xaxis: %{title: %{text: "x"}},
      yaxis: %{title: %{text: "f(x)"}},
      margin: %{t: 40},
      shapes: bracket_shapes(bracket)
    }

    %{plot_data: Jason.encode!(data), plot_layout: Jason.encode!(layout)}
  end

  defp bracket_shapes(nil), do: []

  defp bracket_shapes({left, right}) do
    for x <- [left, right] do
      %{type: "line", x0: x, x1: x, y0: 0, y1: 1, yref: "paper", line: %{color: "#1700e4", dash: "dot"}}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: "Overview",
       function_options: Enum.map(functions(), fn {key, {label, _f}} -> {label, key} end),
       result: nil,
       error: nil,
       bracketing_source: @bracketing_source,
       default_function: @default_function
     )
     |> assign(plot_assigns(@default_function))}
  end

  def handle_event("preview", params, socket) do
    {:noreply, assign(socket, plot_assigns(params["function"]))}
  end

  def handle_event("bracket", params, socket) do
    with {:ok, {_label, f}} <- Map.fetch(functions(), params["function"]),
         {x, ""} <- Float.parse(params["initial_x_value"]),
         {step, ""} <- Float.parse(params["step_length"]),
         {expansion, ""} <- Float.parse(params["expansion_factor"]) do
      {left, right} = SimpleBracketing.bracket_minimum(f, x, step, expansion)

      {:noreply,
       socket
       |> assign(result: {left, right}, error: nil)
       |> assign(plot_assigns(params["function"], {left, right}))}
    else
      _ -> {:noreply, assign(socket, error: "Check your inputs", result: nil)}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="r8-lesson">
        <Layouts.lesson_toc active_topic={:optimization} active_lesson={:optimization} />

        <div class="r8-prose">
          <h1 id="page-heading">An Optimal Optimization Overview</h1>

          <h2>Finding a starting point</h2>
          <p>
            Before an algorithm can zero in on a minimum, it first needs to know roughly where to look.
            Bracketing is how we answer that. In short, Starting from some point, take a step, and keep expanding
            that step until the function starts getting worse again. Once that happens, you know the
            minimum is trapped somewhere between your last two points.
          </p>

          <div class="r8-demo">
            <h3>Try it yourself</h3>
            <p>
              Pick a function below, choose a starting point, and see what interval the bracketing
              algorithm comes back with.
            </p>

            <form phx-submit="bracket" phx-change="preview" class="r8-demo-form">
              <.input
                type="select"
                name="function"
                label="Function"
                options={@function_options}
                value={@default_function}
              />
              <.input type="number" name="initial_x_value" label="Starting x" value="0" step="any" />
              <.input type="number" name="step_length" label="Step length" value="0.01" step="any" />
              <.input type="number" name="expansion_factor" label="Expansion factor" value="2" step="any" />
              <.button variant="primary">Bracket it</.button>
            </form>

            <p :if={@error} class="r8-demo-error">{@error}</p>
            <p :if={@result} class="r8-demo-result">
              Bracket: [{elem(@result, 0) |> Float.round(4)}, {elem(@result, 1) |> Float.round(4)}]
            </p>

            <div
              id="bracketing-function-chart"
              phx-hook="PlotlyChart"
              data-plotly-data={@plot_data}
              data-plotly-layout={@plot_layout}
              style="width: 100%; height: 400px;"
            >
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
