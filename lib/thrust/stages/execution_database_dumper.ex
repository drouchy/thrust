defmodule Thrust.Stages.ExecutionDatabaseDumper do
  use GenStage

  require Logger

  def init(_) do
    {:consumer, []}
  end

  def handle_events(events, args, state) do
    Logger.debug fn -> "Receiving #{Enum.count(events)} for database persistence" end
    {:noreply, [], state}
  end

  def handle_cast(:dump, state) do
    {:noreply, [], state}
  end

  defp dump(requests) do
  end

end
