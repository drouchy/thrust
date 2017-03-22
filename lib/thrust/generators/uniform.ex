defmodule Thrust.Generators.Uniform do

  def distribute(total, nb_slots) do
  (1..nb_slots)
    |> Enum.map(fn (index) ->
      limit = rem(total, nb_slots)
      base = Kernel.div(total, nb_slots)
      if (index <= limit) do
        base + 1
      else
        base
      end
    end)
  end
end