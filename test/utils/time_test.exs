defmodule Thrust.Utils.TimeTest do
  use ExUnit.Case

  alias Thrust.Utils.Time

  test "measure time elapsed for the function execution" do
    {:done, elapsed} = Time.measure fn -> :ok = :timer.sleep 200 ; :done end

    assert_in_delta elapsed, 200, 10
  end
end
