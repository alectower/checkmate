# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :checkmate,
  ecto_repos: [Checkmate.Repo]

# Configures the endpoint
config :checkmate, CheckmateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yS8JubuXYYqmrYQtJ1yyjZxpc7xzipkMywgWO4jGZzwOY/3sdPrBRBZ1VVjLWJ13",
  render_errors: [view: CheckmateWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Checkmate.PubSub,
  live_view: [signing_salt: "6CXdTPYY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines, pug: PhoenixExpug.Engine
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
