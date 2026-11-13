defmodule AlgorithmsForOptimizationWeb.RateLimiter do
  @moduledoc """
  A small fixed-window rate limiter backed by ETS, for throttling public form posts.

      case RateLimiter.hit({:topic_suggestion, ip}, limit: 5, window_ms: :timer.minutes(10)) do
        :ok -> ...
        {:error, :rate_limited} -> ...
      end

  Counts live in a public ETS table owned by this process, so `hit/2` never goes through
  the GenServer and stays cheap under load. Expired windows are swept once a minute.
  State is per node and resets on deploy, which is fine for spam throttling.
  """
  use GenServer

  @table __MODULE__
  @sweep_every :timer.minutes(1)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Records one hit for `key` and returns `:ok` while the count in the current window is
  within `:limit`, or `{:error, :rate_limited}` once it goes over.
  """
  def hit(key, opts) do
    limit = Keyword.fetch!(opts, :limit)
    window_ms = Keyword.fetch!(opts, :window_ms)

    now = System.system_time(:millisecond)
    window = div(now, window_ms)
    expires_at = (window + 1) * window_ms
    bucket = {key, window}

    count = :ets.update_counter(@table, bucket, {2, 1}, {bucket, 0, expires_at})

    if count <= limit, do: :ok, else: {:error, :rate_limited}
  end

  @impl true
  def init(_opts) do
    :ets.new(@table, [
      :named_table,
      :public,
      :set,
      write_concurrency: true,
      read_concurrency: true
    ])

    schedule_sweep()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:sweep, state) do
    now = System.system_time(:millisecond)
    # Delete every {bucket, count, expires_at} row whose window has ended.
    :ets.select_delete(@table, [{{:_, :_, :"$1"}, [{:<, :"$1", now}], [true]}])
    schedule_sweep()
    {:noreply, state}
  end

  defp schedule_sweep, do: Process.send_after(self(), :sweep, @sweep_every)
end
