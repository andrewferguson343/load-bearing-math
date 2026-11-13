defmodule AlgorithmsForOptimization.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AlgorithmsForOptimizationWeb.Telemetry,
      AlgorithmsForOptimization.Repo,
      {DNSCluster, query: Application.get_env(:algorithms_for_optimization, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AlgorithmsForOptimization.PubSub},
      AlgorithmsForOptimizationWeb.RateLimiter,
      # Start a worker by calling: AlgorithmsForOptimization.Worker.start_link(arg)
      # {AlgorithmsForOptimization.Worker, arg},
      # Start to serve requests, typically the last entry
      AlgorithmsForOptimizationWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AlgorithmsForOptimization.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AlgorithmsForOptimizationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
