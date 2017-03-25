defmodule Thrust.Stages.RequestProducer do
  use GenStage

  require Logger

  def init([request: request, generator: generator, total: total, nb_slots: nb_slots]) do
    {
      :producer,
      %{request: request, stream: generator.stream(total, nb_slots, [])},
      dispatcher: GenStage.DemandDispatcher
    }
  end

  def handle_demand(demand, :exhausted) do
    Logger.debug fn -> "Nothing there anymore" end
    {:stop, :exhausted, []}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def handle_cast(:new_requests, :exhausted) do
     Logger.debug fn -> "New requests coming but exhausted" end
    {:noreply, [], :exhausted}
  end

  def handle_cast(:new_requests, state = %{request: request, stream: stream}) do
    nb_requests = Enum.take(stream, 1) |> List.first
    case nb_requests do
      nil ->
        Logger.debug fn -> "New requests coming but exhausted" end
        {:noreply, [], :exhausted}
      _   ->
        Logger.debug fn -> "New requests coming #{nb_requests}" end
        requests = Enum.map(1..nb_requests, fn (_) -> request end)
        new_stream = Enum.drop(stream, 1)

        new_state = Map.merge(state, %{stream: new_stream})
        {:noreply, requests, new_state}
    end
  end
end