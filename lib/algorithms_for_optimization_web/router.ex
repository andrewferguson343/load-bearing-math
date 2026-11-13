defmodule AlgorithmsForOptimizationWeb.Router do
  use AlgorithmsForOptimizationWeb, :router

  import AlgorithmsForOptimizationWeb.SEO, only: [put_canonical_path: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AlgorithmsForOptimizationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_canonical_path
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :admin_basic_auth
  end

  # Crawler files, served dynamically so they can use the configured host.
  scope "/", AlgorithmsForOptimizationWeb do
    get "/robots.txt", SitemapController, :robots
    get "/sitemap.xml", SitemapController, :sitemap
  end

  # Private: read submitted topic suggestions. Credentials come from
  # ADMIN_USERNAME / ADMIN_PASSWORD (see config/runtime.exs); without them it 404s.
  scope "/", AlgorithmsForOptimizationWeb do
    pipe_through [:browser, :admin]

    get "/topic-suggestions", TopicSuggestionController, :index
  end

  scope "/", AlgorithmsForOptimizationWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/topics", PageController, :topics
    post "/topic-suggestions", TopicSuggestionController, :create

    live "/sources", SourcesLive

    live_session :optimization,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :optimization} do
      live "/overview", OverviewLive
      live "/math", MathematicsLive
      live "/optimization", OptimizationLive
      live "/appendix", AppendixLive
    end

    live_session :cosine_similarity,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :cosine_similarity} do
      live "/cosine-similarity", CosineSimilarityLive
      live "/cosine-similarity-math", CosineSimilarityMathLive
      live "/cosine-similarity-implementation", CosineSimilarityImplementationLive
      live "/cosine-similarity-realistic-example", CosineSimilarityRealisticExampleLive
    end

    live_session :leaky_bucket,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :leaky_bucket} do
      live "/leaky-bucket", LeakyBucketLive
    end

    live_session :markov_chains,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :markov_chains} do
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

    live_session :eulers_method,
      on_mount: {AlgorithmsForOptimizationWeb.TopicAuth, :eulers_method} do
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

  defp admin_basic_auth(conn, _opts) do
    case Application.get_env(:algorithms_for_optimization, :admin_basic_auth) do
      [username: username, password: password]
      when is_binary(username) and username != "" and is_binary(password) and password != "" ->
        Plug.BasicAuth.basic_auth(conn, username: username, password: password)

      _not_configured ->
        conn
        |> send_resp(404, "Not Found")
        |> halt()
    end
  end
end
