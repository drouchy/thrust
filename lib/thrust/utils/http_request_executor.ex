defmodule Thrust.Utils.HttpRequestExecutor do
  require Logger

  def execute(request) do
    Logger.debug fn -> "executing request #{request}" end
    %{status_code: status, body: body, headers: headers} = HTTPotion.get "http://localhost:8080/"

    %Thrust.Response{status: status, body: body, headers: headers.hdrs}
  end
end
