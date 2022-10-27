defmodule HappyHourWeb.GameLive.Admin do
  use HappyHourWeb, :live_view
  alias HappyHour.{Games, Repo}
  alias HappyHour.Games.Player

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:game, Games.get_game_by_name!(params["name"]) |> Repo.preload(:players))
      |> assign(:player_changeset, new_player_changeset())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>GameLive <%= assigns.game.name %> Admin</h1>
    <h2>Players</h2>
    <p :if={!length(assigns.game.players) > 0}>No players currently registered for this game.</p>
    <p :for={player <- assigns.game.players}><%= player.name %></p>

    <p>Add a Player</p>
    <.form
      :let={f}
      for={@player_changeset}
      id="add-player"
      phx-submit="save-player">

      <%= label f, :name %>
      <%= text_input f, :name %>
      <%= error_tag f, :name %>

      <div>
        <%= submit "Save", phx_disable_with: "Saving..." %>
      </div>
    </.form>
    """
  end

  def handle_event("save-player", %{"player" => params}, socket) do
    _player = Games.add_player(socket.assigns.game, params)

    {:noreply,
     socket
     |> assign(:game, Games.get_game_by_name!(socket.assigns.game.name))
     |> assign(:changeset, new_player_changeset())}
  end

  def new_player_changeset() do
    Player.changeset(%Player{}, %{})
  end
end
