use Mix.Config

config :thrust, Thrust.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :thrust, Thrust.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "thrust",
  password: "postgres",
  database: "thrust_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
