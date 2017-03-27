defmodule Thrust.Stages.HttpRequestSamplerProducerConsumer do
  use GenStage

  require Logger

  alias Thrust.HttpSampler, as: Sampler

  def init(_options) do
    Logger.debug fn -> "Initialize the sampler stage" end
    {:producer_consumer, %{sampler: Sampler}, dispatcher: GenStage.DemandDispatcher}
  end

  def handle_events(events, args, state) do
    Logger.debug fn -> "Handling #{Enum.count events} event(s)" end
    sampler = Map.get(state, :sampler, Sampler)

    result = Enum.map(events, fn (event) ->
      %{
        request: event,
        response: sampler.sample(event)
      }
    end)
    Logger.debug fn -> "Emitting #{Enum.count result} request sampled" end
    {:noreply, result, state}
  end

end