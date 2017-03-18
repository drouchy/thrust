use Mix.Config

import_config "test.exs"

config :thrust, Thrust.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: nil,
  database: "travis_ci_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
