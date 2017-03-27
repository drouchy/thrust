defmodule Thrust.Statistics.Collector do
  use GenServer

  require Logger

  # Server API
  def start() do
  end

  # Client API
  def start(bucket_name, options \\ []) do
    Logger.debug fn -> "Starting #{bucket_name} statistics collector" end
  end

  def collect(bucket_name, statistics) do
  end

  def compute(bucket_name, formula \\ :all) do
  end
end
