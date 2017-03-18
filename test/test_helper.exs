ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Thrust.Repo, :manual)
{:ok, _pid} = DummyApplication.start
