defmodule AlgorithmsForOptimizationWeb.Router do
  use AlgorithmsForOptimizationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AlgorithmsForOptimizationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AlgorithmsForOptimizationWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/topics", PageController, :topics
    post "/topic-suggestions", TopicSuggestionController, :create
    # Not linked anywhere in the UI; visit directly to read what's come in.
    get "/topic-suggestions", TopicSuggestionController, :index

    live_session :optimization, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :optimization} do
      live "/overview", OverviewLive
      live "/math", MathematicsLive
      live "/optimization", OptimizationLive
      live "/appendix", AppendixLive
    end

    live_session :cosine_similarity, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :cosine_similarity} do
      live "/cosine-similarity", CosineSimilarityLive
    end

    live_session :leaky_bucket, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :leaky_bucket} do
      live "/leaky-bucket", LeakyBucketLive
    end

    live_session :markov_chains, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :markov_chains} do
      live "/markov-chains", MarkovChainsLive
    end

    live_session :pagerank, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :pagerank} do
      live "/pagerank", PageRankLive
    end

    live_session :metastable_failures,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :metastable_failures} do
      live "/metastable-failures", MetastableFailuresLive
    end

    live_session :damped_oscillators,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :damped_oscillators} do
      live "/damped-oscillators", DampedOscillatorsLive
    end

    live_session :eulers_method, on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :eulers_method} do
      live "/eulers-method", EulersMethodLive
    end

    live_session :mathematics_appendix,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :mathematics_appendix} do
      live "/mathematics-appendix", MathematicsAppendixLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AlgorithmsForOptimizationWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:algorithms_for_optimization, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AlgorithmsForOptimizationWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
