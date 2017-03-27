defmodule Thrust.Statistics.CalculatorTest do
  use ExUnit.Case

  alias Thrust.Statistics.Calculator

  @empty_stats %{sum: 0, mean: nil, median: nil,
                 min: nil, max: nil, stdev: nil,
                 percentile_90: nil, percentile_95: nil, percentile_99: nil}

  # compute_for_one_request
  test "computes the data for all the requests in the bucket" do
    bucket = %{ "request_1": [], "request 2": []}

    statistics = Calculator.compute_all(bucket)

    assert Map.get(statistics, :"request_1") == @empty_stats
    assert Map.get(statistics, :"request 2") == @empty_stats
  end

  test "computes the statistics" do
    bucket = %{"request_1": [10, 20, 30, 15, 6]}

    statistics = Calculator.compute_all(bucket) |> Map.get(:"request_1")

    assert statistics == %{mean: 16.2, median: 15, min: 6, max: 30, sum: 81, stdev: 8.35224520712844,
                           percentile_90: 26.0, percentile_95: 28.0, percentile_99: 29.6}
  end
end
