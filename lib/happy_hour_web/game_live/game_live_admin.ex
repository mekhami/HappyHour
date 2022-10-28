defmodule HappyHourWeb.GameLive.Admin do
  use HappyHourWeb, :live_view
  alias HappyHour.{Games, Repo}
  alias HappyHour.Games.Player

  def mount(params, _session, socket) do
    game =
      Games.get_game_by_name!(params["name"])
      |> Repo.preload(:players)

    socket =
      socket
      |> assign(:game, game)
      |> assign(:players, game.players)
      |> assign(:player_changeset, new_player_changeset())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>GameLive <%= assigns.game.name %> Admin</h1>
    <h2>Players</h2>
    <p :if={length(assigns.players) == 0}>No players currently registered for this game.</p>
    <p :for={player <- assigns.players}><%= player.name %></p>

    <h2>Add a Player</h2>
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
    new_player = Games.add_player(socket.assigns.game, params)

    {:noreply,
     socket
     |> assign(:players, [new_player | socket.assigns.game.players])
     |> assign(:changeset, new_player_changeset())}
  end

  def new_player_changeset() do
    Player.changeset(%Player{}, %{})
  end
end
