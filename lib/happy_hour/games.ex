defmodule HappyHour.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias HappyHour.Repo

  alias HappyHour.Games.{Game, Player, Question}

  @doc """
  Returns the list of games.

  ## Examples

  iex> list_games()
  [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
    |> Repo.preload([:players, :questions])
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

  iex> get_game!(123)
  %Game{}

  iex> get_game!(456)
  ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id) |> Repo.preload([:players, :questions])

  @doc """
  Gets a single game by its name.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

  iex> get_game_by_name!("foo")
  %Game{name: "foo"}

  iex> get_game!("not in the database")
  ** (Ecto.NoResultsError)

  """
  def get_game_by_name!(name) do
    Repo.get_by!(Game, name: name)
    |> Repo.preload([:players, :questions])
  end

  @doc """
  Creates a game.

  ## Examples

  iex> create_game(%{field: value})
  {:ok, %Game{}}

  iex> create_game(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    game =
      %Game{}
      |> Game.changeset(attrs)
      |> Repo.insert()

    case game do
      {:ok, game} ->
        {:ok, Repo.preload(game, [:players, :questions])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a game.

  ## Examples

  iex> update_game(game, %{field: new_value})
  {:ok, %Game{}}

  iex> update_game(game, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

  iex> delete_game(game)
  {:ok, %Game{}}

  iex> delete_game(game)
  {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

  iex> change_game(game)
  %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def add_player(%Game{} = game, attrs \\ %{}) do
    # Add the game id to the player attrs?
    # associate the game to the player somehow before the repo insert?
    Player.changeset(%Player{}, attrs)
    |> Ecto.Changeset.put_assoc(:game, game)
    |> Repo.insert!()
  end

  def remove_player(%Game{} = _game, %Player{} = player) do
    player
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.no_assoc_constraint(:questions)
    |> Repo.delete()
  end

  def add_question(%Game{} = game, question_text, %Player{} = player) do
    question = %Question{text: question_text, player: player}

    game
    |> Ecto.build_assoc(:questions, question)
    |> Repo.insert!()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  def get_random_question(%Game{} = game) do
    try do
      game.questions
      |> Enum.filter(&(&1.answered == false))
      |> Enum.random()
    rescue
      Enum.EmptyError ->
        {:error, :no_unanswered_questions}
    end
  end

  def answer_question(%Question{} = question) do
    question
    |> Question.changeset(%{answered: true})
    |> Repo.update()
  end
end
