defmodule HappyHour.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add(:name, :string)
      add(:game_id, references(:games))

      timestamps()
    end
  end
end
