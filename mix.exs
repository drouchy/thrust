defmodule Thrust.Mixfile do
  use Mix.Project

  def project do
    [app: :thrust,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_pattern: "*_{test,check}.exs",
     aliases: aliases(),
     dialyzer: [plt_add_deps: :transitive],
     test_coverage: [tool: ExCoveralls],
     deps: deps()]
  end

  def application do
    [mod: {Thrust, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :httpotion]]
  end

  defp elixirc_paths(:travis), do: elixirc_paths(:test)
  defp elixirc_paths(:test),   do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),       do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:gettext, "~> 0.11"},
     {:timex, "~> 3.1"},
     {:httpotion, "~> 3.0"},
     {:cowboy, "~> 1.0"},
     {:statistics, "~> 0.4.0"},
     {:gen_stage, "~> 0.11"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:mix_test_watch, "~> 0.3.3", only: [:dev, :test], runtime: false},
     {:eqc_ex, "~> 1.4", only: [:dev, :travis, :test]},
     {:excoveralls, "~> 0.6", only: [:test, :travis]},
     {:dialyxir, "~> 0.5", only: [:dev, :travis], runtime: false}]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test":       ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
