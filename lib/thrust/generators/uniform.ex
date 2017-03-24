defmodule Thrust.Generators.Uniform do
  @behaviour Generator

  require Logger

  def distribute(total, nb_slots, _options \\ []) do
  (1..nb_slots)
    |> Enum.map(fn (index) ->
      slot_value(index, total, nb_slots)
    end)
  end

  def stream(total, nb_slots, [type: :infinite]) do
    Logger.debug fn ->  "Building an uniform infinite stream" end

    stream(total, nb_slots, [])# |> Stream.cycle
  end

  def stream(total, nb_slots, _options) do
    Logger.debug fn ->  "Building a uniform finite stream" end

    Stream.resource( fn -> Enum.to_list 1..nb_slots end,
      fn(slots) ->
        case slots do
          []            -> {:halt, nb_slots}
          [slot|rest]   -> {[slot_value(slot, total, nb_slots)], rest}
        end
      end,
      fn (_) -> end)
  end

  defp slot_value(index, total, nb_slots) do
    limit = rem(total, nb_slots)
    base = Kernel.div(total, nb_slots)
    if (index <= limit) do
      base + 1
    else
      base
    end
  end
end