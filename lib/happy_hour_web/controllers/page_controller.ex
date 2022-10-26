defmodule HappyHourWeb.PageController do
  use HappyHourWeb, :controller
  alias HappyHour.Games

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"post" => params}) do
    {:ok, game} = Games.create_game(%{name: params["name"]})
    redirect(conn, to: Routes.live_path(conn, HappyHourWeb.GameLive.Show, game.name))
  end
end
