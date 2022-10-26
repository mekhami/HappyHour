defmodule HappyHourWeb.GameLive.Show do
  use Phoenix.LiveView
  alias HappyHour.Games

  def mount(params, _session, socket) do
    {:ok, assign(socket, :game, Games.get_game_by_name!(params["name"]))}
  end

  def render(assigns) do
    ~H"""
    <p>GameLive <%= assigns.game.name %> Show</p>
    """
  end
end
