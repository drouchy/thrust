defmodule Thrust.Stages.RequestProducerTest do
  use ExUnit.Case, async: true

  alias Thrust.Stages.RequestProducer, as: Producer

  @request %{method: :get}
  @generator Thrust.Generators.Uniform
  @total 10
  @nb_slots 3

  #init/1
  test "it is a Genstage producer" do
    {:producer, _, dispatcher: GenStage.DemandDispatcher} = one_producer
  end

  test "converts the keywords to a map" do
    {_, %{request: @request, stream: stream}, _} = one_producer

    assert Enum.to_list(stream) == [4, 3, 3]
  end

  #handle_demand/2
  test "returns the expected Genstage response" do
    state = %{request: @request, stream: one_stream}

    {:noreply, [], ^state} = Producer.handle_demand(2, state)
  end

  #handle_cast/2
  test "returns the expected handle_cast format" do
    state = %{request: @request, stream: one_stream}

    {:noreply, _, _} = Producer.handle_cast(:new_requests, state)
  end

  test "generates events" do
    state = %{request: @request, stream: one_stream}

    {:noreply, events, _} = Producer.handle_cast(:new_requests, state)

    assert events == [@request, @request, @request, @request]
  end

  test "takes some data from the stream" do
    state = %{request: @request, stream: one_stream}

    {:noreply, _, %{stream: stream}} = Producer.handle_cast(:new_requests, state)

    assert Enum.to_list(stream) == [3, 3]
  end

  test "returns the new requests" do
    state = %{request: @request, stream: one_stream}

    {:noreply, requests, _} = Producer.handle_cast(:new_requests, state)

    assert Enum.count(requests) == 4
  end

  defmodule ExampleConsumer do
    use GenStage

    def init(process) do
      {:consumer, process}
    end

    def handle_events(events, _, process) do
      send(process, "#{Enum.count(events)} events received")
      {:noreply, [], process}
    end
  end

  test "end-to-end test for the Producer" do
    {:ok, producer} = GenStage.start_link(Producer, request: @request, generator: Thrust.Generators.Uniform, total: 10, nb_slots: 3)
    {:ok, consumer} = GenStage.start_link(ExampleConsumer, self)

    GenStage.sync_subscribe(consumer, to: producer)
    GenStage.cast(producer, :new_requests)
    GenStage.cast(producer, :new_requests)
    GenStage.cast(producer, :new_requests)

    assert_receive "4 events received", 100
    assert_receive "3 events received", 100
    assert_receive "3 events received", 100
  end

  defp one_producer, do: Producer.init(request: @request, generator: @generator, total: @total, nb_slots: @nb_slots)
  defp one_stream, do: Thrust.Generators.Uniform.stream(10, 3, [])
end