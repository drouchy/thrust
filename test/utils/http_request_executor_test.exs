defmodule Thrust.Utils.HttpRequestExecutorTest do
  use ExUnit.Case

  alias Thrust.Utils.HttpRequestExecutor, as: Executor

  test "returns the http response" do
    %Thrust.Response{status: 200, body: "Welcome", headers: headers, error: nil} = Executor.execute(%{method: "get", path: "/", host: "http://localhost:8080"})

    assert Map.get(headers, "x-request-id") == "custom-value"
  end

  # test "executing the request returns an error for an incorrect host" do
  #   %Thrust.Response{error: message} = Executor.execute(%{method: "get", path: "/", host: "http://localhost:8089"})

  #   assert message == ""
  # end
end
