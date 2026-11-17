defmodule AlgorithmsForOptimizationWeb.LittlesLawLive do
  @moduledoc """
  Point Load: Little's Law. A single-page quickie on L = λW.
  """
  use AlgorithmsForOptimizationWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Little's Law")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="lbm-lesson">
        <Layouts.lesson_toc active_topic={:littles_law} active_lesson={:overview} />
        <div class="lbm-prose">
          <h1 id="page-heading">Little's Law</h1>

          <p>
            Little's Law relates how many things are in a system, how fast they show up, and how long they stay. It doesn't care about the
            internal machinery. As long as the system can handle the load, the math holds. Waiting in the subzero temperatures at Stowe Mountain's gondola while you slowly lose feeling in your feet? Little's Law.
            Requests piling up behind a handful of overworked server threads while your phone rings at 2 A.M.? Little's Law.
          </p>
          <h2>The Gondola</h2>
          <p>
            I'm pulling into the parking lot at Stowe. I grab my skis and trudge up the dreadful hill to the gondola, and what do I see? A line stretching almost back to the parking lot. Shit. How long am I going to
            have to wait to shred that East Coast pow?
          </p>
          <p>Little's Law is as follows:</p>
          <p>$$L = \lambda W$$</p>
          <p>For my wait time, here's what each letter means:</p>
          <ul>
            <li>$L$ is the number of people in line</li>
            <li>$\lambda$ is the number of people arriving per minute</li>
            <li>
              $W$ is the amount of time it takes a person standing at the back of the line to be in that nice, cozy gondola cabin
            </li>
          </ul>

          <p>
            To estimate my wait time, we need to solve the equation for $W$:
          </p>
          <p>{"$$W = \\frac{L}{\\lambda}$$"}</p>
          <p>
            Now we need some values. I know the gondola opens at 8 A.M., so I try to get there right when it opens. However, on the way I have to pee,
            grab coffee, and, of course, stash a few lift beers in my bag. Now everybody and their mother is in line. By my estimate, there are around 800 people. Stowe's gondola
            moves around 2,800 people per hour, or around 47 per minute. The line doesn't seem to be growing anymore, so the gondola is keeping up with arrivals. We can use the gondola's load rate for $\lambda$.
          </p>
          <p>Alright, let's plug and chug:</p>
          <p>
            {"$$W = \\frac{800 \\text{ people}}{47 \\text{ people/min}} \\approx 17 \\text{ min}$$"}
          </p>
          <p>This is great: I only have to be cold for around 17 minutes! Little's Law!</p>
          <p>
            In this example, we entered the system when we joined the line, and we exited when we sat down in the cabin. Remember, this only holds in a stable system.
          </p>

          <h2>Your Server Is a Gondola</h2>

          <p>
            Now let's look at this from a server's perspective. Here, $L$ is the number of requests in flight, $\lambda$ is the number of requests arriving per second, and $W$ is the latency (which is just the processing time when there's no line).
          </p>

          <p>
            Let's say we're taking in 230 requests per second and each takes 60 ms (0.06 s) to process. That gives us:
          </p>
          <p>
            {"$$L = 230 \\text{ req/s} \\times 0.06 \\text{ s} = 13.8 \\text{ requests}$$"}
          </p>
          <p>
            Our server only has 8 worker threads. Now there's a real problem. With 8 workers at 0.06 s each, the most we can process is:
          </p>
          <p>
            {"$$\\frac{8 \\text{ workers}}{0.06 \\text{ s}} \\approx 133 \\text{ req/s}$$"}
          </p>
          <p>
            With 230 arriving, the server falls behind by about 97 requests every second, and the gondola line never stops growing. I have to stay cold forever.
          </p>
          <p>
            To have a stable system, we would need around 14 workers, but they'd be 99% busy. Scaling up to 18 keeps the workers around 75% busy, allowing for some extra headroom so a burst of traffic doesn't bring the line right back.
          </p>

          <h2>You Won't Just See It a Little</h2>

          <p>
            Little's Law shows up everywhere once you start looking. It's how your monitoring knows how much trouble you're in. A queue that keeps growing means $L$ is climbing, and dividing it by how fast you're actually getting through requests tells you how far behind you are in actual time.
            It's how you size connection and thread pools to avoid being called at 2 A.M. without burning a hole in the company's wallet, and it's even hidden inside rate limiters.
          </p>

          <p>
            You only need to know two things: how many are in the box and how fast they're leaving. Now you know how long, on average, anything is going to wait. Alright, I'm gonna go shred that pow. Thanks for reading.
          </p>
        </div>
      </div>
      <Layouts.topic_end_note active_topic={:littles_law} active_lesson={:overview} />
    </Layouts.app>
    """
  end
end
