defmodule DummyApplication do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
      |> put_resp_header("X-Request-Id", "custom-value")
      |> send_resp(200, "Welcome")
  end

  get "/slow" do
    Process.sleep 50
    conn
      |> put_resp_header("X-Request-Id", "custom-value")
      |> send_resp(200, "This is slow")
  end

  match _, do: send_resp(conn, 404, "Oops!")

  def start do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, DummyApplication, [], port: 8080)
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule Scenario do
  def start do
    {:ok, dummy} = DummyApplication.start

    request = URI.parse("http://localhost:8080")

    # p = [request: request, generator: Thrust.Generators.Uniform, total: 1000, nb_slots: 30]
    p = [request: request, generator: Thrust.Generators.Uniform, total: 500, nb_slots: 10]
    {:ok, producer} = GenStage.start_link(Thrust.Stages.RequestProducer, p)
    {:ok, consumer_1} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_2} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_3} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_4} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_5} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_6} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_7} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_8} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, consumer_9} = GenStage.start_link(Thrust.Stages.HttpRequestSamplerProducerConsumer, nil)
    {:ok, final_consumer} = GenStage.start_link(Thrust.Stages.ExecutionDatabaseDumper, nil)

    {:ok, subscription_reference_1} = GenStage.sync_subscribe(consumer_1, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_2} = GenStage.sync_subscribe(consumer_2, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_3} = GenStage.sync_subscribe(consumer_3, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_4} = GenStage.sync_subscribe(consumer_4, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_5} = GenStage.sync_subscribe(consumer_5, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_6} = GenStage.sync_subscribe(consumer_6, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_7} = GenStage.sync_subscribe(consumer_7, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_8} = GenStage.sync_subscribe(consumer_8, to: producer, min_demand: 0, max_demand: 1, interval: 100)
    {:ok, subscription_reference_9} = GenStage.sync_subscribe(consumer_9, to: producer, min_demand: 0, max_demand: 1, interval: 100)

    GenStage.sync_subscribe(final_consumer, to: consumer_1, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_2, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_3, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_4, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_5, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_6, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_7, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_8, min_demand: 1, max_demand: 100)
    GenStage.sync_subscribe(final_consumer, to: consumer_9, min_demand: 1, max_demand: 100)

    Thrust.Quartz.start(:requests, fn -> GenServer.cast(producer, :new_requests) end)
    Thrust.Quartz.start(:dump,     fn -> GenServer.cast(final_consumer, :dump)   end, every: 10_000)
  end

  def stop do
    Thrust.Quartz.stop(:requests)
    Thrust.Quartz.stop(:dump)
  end
end
