defmodule DummyApplication do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
      |> put_resp_header("X-Request-Id", "custom-value")
      |> send_resp(200, "Welcome")
  end

  get "/slow" do
    Process.sleep 50
    conn
      |> put_resp_header("X-Request-Id", "custom-value")
      |> send_resp(200, "This is slow")
  end

  match _, do: send_resp(conn, 404, "Oops!")

  def start do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, DummyApplication, [], port: 8080)
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
