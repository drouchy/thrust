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
            timers:  Map.put(timers, name, start_timer(to_execute, options[:every]))
          }
        end)
        :ok
      _ -> :already_exist
    end
  end

  defp start_timer(to_execute, every) do
    {:ok, ref} = :timer.apply_interval(every, Thrust.Quartz, :execute, [to_execute])
    ref
  end

  def stop(agent, name) do
    case Agent.get(agent, fn (state) -> Map.get(state, :timers) |> Map.get(name) end) do
      nil -> :not_found
      ref -> :timer.cancel(ref)
    end
  end

  def execute(to_execute) do
    to_execute.()
  end
end