defmodule Thrust.Utils.HttpRequestExecutorTest do
  use ExUnit.Case

  alias Thrust.Utils.HttpRequestExecutor, as: Executor

  test "returns the http response" do
    %Thrust.Response{status: 200, body: "Welcome", headers: headers, error: nil} = Executor.execute(%{method: "get", path: "/", host: "localhost", port: 8080, scheme: "http"})

    assert Map.get(headers, "x-request-id") == "custom-value"
  end

  test "executing the request returns an error for an incorrect host" do
    %Thrust.Response{error: message} = Executor.execute(%{method: "get", path: "/", host: "localhost", port: 8089, scheme: "http"})

    assert message == "econnrefused"
  end
end
