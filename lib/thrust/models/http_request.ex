defmodule Thrust.HttpRequest do
  defstruct name: "default request", host: nil, port: 80, path: "/", scheme: "http", method: "get", headers: %{}, parameters: %{}, body: nil
end