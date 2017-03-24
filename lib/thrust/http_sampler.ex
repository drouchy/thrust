defmodule Thrust.HttpSampler do
  require Logger

  alias Thrust.Utils.HttpRequestExecutor, as: Executor
  alias Thrust.Utils.Time

  def sample(request) do
    Logger.debug fn -> "sampling request #{inspect request}" end
    {response, duration} = Time.measure fn -> Executor.execute(request) end
    Map.put response, :elapsed , duration
  end
end