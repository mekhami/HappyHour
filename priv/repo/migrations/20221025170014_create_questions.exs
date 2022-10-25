defmodule HappyHour.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:text, :string)
      add(:answered, :boolean, default: false, null: false)
      add(:player_id, references(:players))
      add(:game_id, references(:games))

      timestamps()
    end
  end
end
