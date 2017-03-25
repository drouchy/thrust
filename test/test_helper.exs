ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Thrust.Repo, :manual)

case Process.whereis(DummyApplication) do
  nil -> :ok
  pid -> Process.exit(pid, :normal)
end

{:ok, _pid} = DummyApplication.start
