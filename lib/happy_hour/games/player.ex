defmodule HappyHour.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "players" do
    field :name, :string
    has_many :questions, HappyHour.Games.Question
    belongs_to :game, HappyHour.Games.Game

    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
