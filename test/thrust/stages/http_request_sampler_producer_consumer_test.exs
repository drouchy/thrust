defmodule Thrust.Stages.HttpRequestSamplerProducerConsumerTest do
  use ExUnit.Case, async: true

  alias Thrust.Stages.HttpRequestSamplerProducerConsumer, as: Producer

  #init/1
  test "it is a Genstage producer/consumer" do
    {:producer_consumer, %{sampler: Thrust.HttpSampler}, dispatcher: GenStage.DemandDispatcher} = one_producer_consumer
  end

  #handle_events/3
  defmodule FakeSampler do
    def sample(_) do
      %{elapsed: 1, response: :response}
    end
  end

  test "returns the expected Genstage response" do
    {:noreply, _, %{}} = Producer.handle_events([], nil, %{})
  end

  test "Samples the events & returns the result" do
    {:noreply, events, %{sampler: FakeSampler}} = Producer.handle_events(two_events(), nil, %{sampler: FakeSampler})

    [%{request: request, response: %{elapsed: 1, response: :response}}, _] = events
    assert request == one_request
  end

  defp one_producer_consumer, do: Producer.init(nil)
  defp one_request, do: URI.parse("http://localhost:8080")
  defp two_events, do: [one_request(), one_request()]
end