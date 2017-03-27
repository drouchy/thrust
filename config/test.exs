use Mix.Config

config :thrust, Thrust.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :error

config :thrust, Thrust.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "thrust",
  password: "postgres",
  database: "thrust_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :thrust,
  nb_test_per_check: 200

config :thrust, Thrust.Quartz,
  every: 100