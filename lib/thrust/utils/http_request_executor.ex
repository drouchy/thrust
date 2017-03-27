defmodule Thrust.Utils.HttpRequestExecutor do
  require Logger

  def execute(request) do
    Logger.debug fn -> "executing request #{inspect request}" end

    case HTTPotion.get build_url(request) do
    	%{status_code: status, body: body, headers: headers} -> %Thrust.HttpResponse{status: status, body: body, headers: headers.hdrs}
    	%{message: message}                                  -> %Thrust.HttpResponse{error: message}
    end
  end

  defp build_url(request) do
  	URI.to_string Map.merge(%URI{}, request)
  end
end
