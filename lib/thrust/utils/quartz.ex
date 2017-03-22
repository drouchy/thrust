defmodule Thrust.Quartz do
  def start_link do
    start_link(every: 1000)
  end

  def start_link(options) do
    Agent.start_link(fn -> %{options: options, timers: %{}} end, name: :quartz)
  end

  def start(agent, name, to_execute) do
    case Agent.get(agent, fn (state) -> Map.get(state, :timers) |> Map.get(name) end) do
      nil -> 
        Agent.update(agent, fn(state) ->
          options = Map.get(state, :options)
          timers  = Map.get(state, :timers)
          %{
            options: options,
            timers:  Map.put(timers, name, spawn fn -> execute(to_execute, options[:every]) end)
          }
        end)
        :ok
      _ -> :already_exist
    end
  end

  def stop(agent, name) do
    case Agent.get(agent, fn (state) -> Map.get(state, :timers) |> Map.get(name) end) do
      nil -> :not_found
      pid -> Process.exit(pid, :kill)
    end
  end

  defp execute(to_execute, every) do
    Process.sleep(every)
    to_execute.()
    execute(to_execute, every)
  end
end