defmodule HappyHour.Games.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :answered, :boolean, default: false
    field :text, :string
    belongs_to :player, HappyHour.Games.Player
    belongs_to :game, HappyHour.Games.Game

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :answered])
    |> validate_required([:text, :answered])
  end
end
