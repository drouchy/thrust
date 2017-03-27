defmodule Thrust.Quartz do
  require Logger

  def start_link do
    Logger.info "Starting quartz with a schedule config #{inspect Application.get_env(:thrust, Thrust.Quartz)}"
    start_link(Application.get_env(:thrust, Thrust.Quartz))
  end

  def start_link(options) do
    Agent.start_link(fn -> %{options: options, timers: %{}} end, name: Keyword.get(options, :name, :quartz))
  end

  def start(agent, name, to_execute, args) do
    case Agent.get(agent, fn (state) -> Map.get(state, :timers) |> Map.get(name) end) do
      nil ->
        Agent.update(agent, fn(state) ->
          options = Keyword.merge(Map.get(state, :options), args)
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
    case Agent.get(agent, fn (state) -> get_in(state, [:timers, name]) end) do
      nil -> :not_found
      ref ->
        :timer.cancel(ref)
        Agent.update(agent, fn(state) -> put_in(state, [:timers, name], nil) end)
    end
  end

  def execute(to_execute) do
    to_execute.()
  end

  # Client API
  def start(name, to_execute, args \\ []) do
    Logger.debug fn -> "Starting the #{name} scheduler with options #{inspect args}" end
    Thrust.Quartz.start(:quartz, name, to_execute, args)
  end

  def stop(name) do
    Logger.debug fn -> "Stopping the #{name} scheduler" end
    Thrust.Quartz.stop(:quartz, name)
  end
end