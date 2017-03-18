defmodule Thrust.Utils.Time do
  require Logger

  alias Timex.Duration

  def measure(execution) do
    Logger.debug fn -> "Measuring execution time" end
    start_execution = Duration.now
    result = execution.()
    duration = Duration.diff(Duration.now, start_execution, :milliseconds)

    {result, duration}
  end
end
