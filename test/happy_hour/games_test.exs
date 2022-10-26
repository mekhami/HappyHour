defmodule HappyHour.GamesTest do
  use HappyHour.DataCase

  alias HappyHour.Games
  alias HappyHour.Games.{Player, Question}

  describe "games" do
    alias HappyHour.Games.Game

    import HappyHour.GamesFixtures

    @invalid_attrs %{name: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end

    test "add_player/2 adds a player to a game" do
      game = game_fixture()
      assert %Player{} = Games.add_player(game, %{name: "Lawrence"})
      game = Games.get_game!(game.id) |> Repo.preload(:players)
      assert [%Player{name: "Lawrence"}] = game.players
    end

    test "add_question/3 adds a question to a game for a player" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      assert %Question{} = Games.add_question(game, "who are you", player)
      game = Games.get_game!(game.id) |> Repo.preload(:questions)
      assert [%Question{text: "who are you"}] = game.questions
    end

    test "add_question/3 can add more than one question for a player" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      assert %Question{} = Games.add_question(game, "who are you", player)
      assert %Question{} = Games.add_question(game, "what are you", player)
      assert %Question{} = Games.add_question(game, "when are you", player)
      game = Games.get_game!(game.id) |> Repo.preload(:questions)
      assert length(game.questions) == 3
    end

    test "delete_question/3 can delete a question from a game" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      assert %Question{} = Games.add_question(game, "who are you", player)
      question_to_delete = Games.add_question(game, "when are you", player)
      Games.delete_question(question_to_delete)

      game = Games.get_game!(game.id) |> Repo.preload(:questions)
      assert length(game.questions) == 1
    end

    test "remove_player/2 can delete a player from a game" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      Games.remove_player(game, player)
      game = Games.get_game!(game.id) |> Repo.preload(:players)

      assert length(game.players) == 0
    end

    test "remove_player/2 deletes a players questions from a game" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      assert %Question{} = Games.add_question(game, "who are you", player)
      Games.remove_player(game, player)
      game = Games.get_game!(game.id) |> Repo.preload([:players, :questions])

      assert length(game.players) == 0
      assert length(game.questions) == 0
    end

    test "random_question/1 gets a question that is not answered from the game" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      assert %Question{} = Games.add_question(game, "who are you", player)

      Games.add_question(game, "what are you", player)
      |> Games.answer_question()

      game = Games.get_game!(game.id) |> Repo.preload([:players, :questions])
      assert %Question{answered: false} = Games.get_random_question(game)
    end

    test "answer_question/2 marks a question as answered in a game" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      question = Games.add_question(game, "who are you", player)

      {:ok, question} = Games.answer_question(question)
      assert question.answered == true
    end

    test "random_question/1 cannot get a question that is already answered" do
      game = game_fixture()
      player = Games.add_player(game, %{name: "Lawrence"})
      question = Games.add_question(game, "who are you", player)

      {:ok, question} = Games.answer_question(question)

      game = Games.get_game!(game.id) |> Repo.preload([:players, :questions])
      assert {:error, :no_unanswered_questions} = Games.get_random_question(game)
    end
  end
end
