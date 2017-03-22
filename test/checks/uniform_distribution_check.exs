defmodule Thrust.Checks.Generators.UniformTest do
  use ExUnit.Case, async: true
  use EQC.ExUnit

  alias Thrust.Generators.Uniform, as: Generator
  @moduletag :quickcheck
  @nb_tests Application.get_env(:thrust, :nb_test_per_check, 100)

  def total_generator, do: choose(1000, 300_000)
  def nb_slots, do: choose(60, 36_000)

  @tag numtests: @nb_tests
  property "distribute all the requests in slots" do
    forall {nb_slots, total} <- {nb_slots, total_generator} do
      distribution = Generator.distribute(total, nb_slots)
      boundaries = Kernel.div(total, nb_slots)..(Kernel.div(total, nb_slots) + 1)

      correct? = Enum.count(distribution) == nb_slots &&
                 Statistics.sum(distribution) == total  &&
                 Enum.all?(distribution, fn (x) -> x in boundaries end)

      ensure correct? == true
    end
  end
end
