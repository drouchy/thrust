defmodule Thrust.Statistics.Calculator do
  require Logger

  def compute_all(bucket) do
    Enum.map(bucket, fn ({name, data}) -> compute_for_one_request(name, data) end)
      |> Enum.into(%{})
  end

  defp compute_for_one_request(name, data) do
    Logger.debug fn -> "Computing the Statistics for the request #{name}" end
    {name , %{sum: Statistics.sum(data),
              mean: Statistics.mean(data),
              median: Statistics.median(data),
              min: Statistics.min(data),
              max: Statistics.max(data),
              stdev: Statistics.stdev(data),
              percentile_90: Statistics.percentile(data, 90),
              percentile_95: Statistics.percentile(data, 95),
              percentile_99: Statistics.percentile(data, 99)}}
  end
end
