defmodule HappyHourWeb.GameLive.Admin do
  use Phoenix.LiveView

  def mount(params, _session, socket) do
    {:ok, assign(socket, :game, params["name"])}
  end

  def render(assigns) do
    ~H"""
    <p>GameLive <%= assigns.game %> Admin</p>
    """
  end
end
