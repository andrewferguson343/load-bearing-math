defmodule AlgorithmsForOptimizationWeb.LeakyBucketLive do
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "The Leaky Bucket")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="c8-lesson">
        <Layouts.lesson_toc active_topic={:leaky_bucket} active_lesson={:overview} />

        <div class="c8-prose">
          <h1 id="page-heading">The Leaky Bucket</h1>

          <%!-- <h2>A differential equation holding back the flood</h2>
          <p>
            Picture a bucket with a hole in the bottom. Water drips in whenever a request comes in, and
            drains out at some fixed rate no matter what. If requests show up faster than the bucket
            drains, it fills up, and once it's full, anything else poured in just spills over the side.
            That overflow is your 429. The fill level over time is governed by a simple differential
            equation, and that one equation is quietly running the rate limiter in front of nearly every
            API you've ever hit.
          </p> --%>

          <h2>More coming soon</h2>
          <p>
            Check back soon, or use the suggest a topic button above if there's something specific you'd like covered first.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
