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
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
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
    game
    |> Ecto.build_assoc(:players, attrs)
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
