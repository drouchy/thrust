defmodule Thrust.PageControllerTest do
  use Thrust.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome,"
  end
end
