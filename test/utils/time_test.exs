defmodule Thrust.Utils.TimeTest do
  use ExUnit.Case, async: true

  alias Thrust.Utils.Time

  test "measure time elapsed for the function execution" do
    {:done, elapsed} = Time.measure fn -> :ok = Process.sleep 200 ; :done end

    assert_in_delta elapsed, 200, 10
  end
end
