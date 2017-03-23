defmodule Thrust do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Thrust.Repo, []),
      supervisor(Thrust.Endpoint, []),
      worker(Thrust.Supervisors.SchedulerSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Thrust.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Thrust.Endpoint.config_change(changed, removed)
    :ok
  end
end
