defmodule Thrust.HttpSamplerTest do
	use ExUnit.Case

	alias Thrust.HttpSampler, as: Sampler

  test "execute the request" do
    %Thrust.Response{status: 200, body: "Welcome", headers: headers, error: nil} = Sampler.sample request
  end

	test "measure the time of execution" do
    %{elapsed: time} = Sampler.sample Map.put(request, :path, "/slow")

    assert_in_delta time, 50, 30
  end

  def request, do: URI.parse("http://localhost:8080")
end