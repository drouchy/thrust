use Mix.Config

config :thrust,
  ecto_repos: [Thrust.Repo]

config :thrust, Thrust.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "q260Ph+npZ9AUrc1M30M/PpkXk2DukRpLwXIBsftYZwrLEBPVZin30njFFRRqudv",
  render_errors: [view: Thrust.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Thrust.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $levelpad$message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"