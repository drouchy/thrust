defmodule Thrust.Generators.UniformTest do
  use ExUnit.Case, async: true

  alias Thrust.Generators.Uniform

  # distribute
  test "Distributes the load evently in each slot" do
    assert Uniform.distribute(10, 3) == [4, 3, 3]
  end

  # stream
  test "builds a finite stream of load" do
    stream  = Uniform.stream(10, 3) |> Enum.take(10)

    assert stream == [4, 3, 3]
  end

  test "can builds an infinite stream" do
    stream = Uniform.stream(10, 3, type: :infinite) |> Enum.take(10)

    assert stream == [4, 3, 3, 4, 3, 3, 4, 3, 3, 4]
  end
end