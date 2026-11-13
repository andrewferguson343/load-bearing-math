# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :algorithms_for_optimization,
  ecto_repos: [AlgorithmsForOptimization.Repo],
  generators: [timestamp_type: :utc_datetime]

# Topics flipped on here are visible to everyone. Keep a topic off this list
# while you're still working on it; dev_routes (config/dev.exs) shows it to
# you locally regardless. See AlgorithmsForOptimization.Topics.
config :algorithms_for_optimization, public_topics: [
  :cosine_similarity,
  :leaky_bucket
]

# Configure the endpoint
config :algorithms_for_optimization, AlgorithmsForOptimizationWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [
      html: AlgorithmsForOptimizationWeb.ErrorHTML,
      json: AlgorithmsForOptimizationWeb.ErrorJSON
    ],
    layout: false
  ],
  pubsub_server: AlgorithmsForOptimization.PubSub,
  live_view: [signing_salt: "Lmza/xqd"]

# Configure LiveView
config :phoenix_live_view,
  # the attribute set on all root tags. Used for Phoenix.LiveView.ColocatedCSS.
  root_tag_attribute: "phx-r"

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :algorithms_for_optimization, AlgorithmsForOptimization.Mailer,
  adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  algorithms_for_optimization: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --chunk-names=chunks/[name]-[hash] --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=. --alias:katex=./vendor/katex.min.js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.3.0",
  algorithms_for_optimization: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Throttle the public "Suggest a Topic" form per visitor IP.
config :algorithms_for_optimization, :topic_suggestion_rate_limit,
  limit: 5,
  window_ms: :timer.minutes(10)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
