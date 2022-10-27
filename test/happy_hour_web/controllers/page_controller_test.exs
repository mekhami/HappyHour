defmodule HappyHourWeb.PageControllerTest do
  use HappyHourWeb.ConnCase
  alias HappyHour.Games
  alias HappyHour.Games.Game

  test "redirects to show when data is valid", %{conn: conn} do
    name = "Foobar"
    conn = post(conn, Routes.page_path(conn, :create), %{name: name})

    assert %{name: name} == redirected_params(conn)
    assert redirected_to(conn) == Routes.live_path(conn, HappyHourWeb.GameLive.Show, name)
    assert %Game{name: ^name} = Games.get_game_by_name!(name)
  end
end
