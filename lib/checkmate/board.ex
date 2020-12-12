defmodule Checkmate.Board do
  defstruct [:pieces]

  def init do
    %__MODULE__{
      pieces: [
        "wr", "wn", "wb", "wq", "wk", "wb", "wn", "wr",
        "wp", "wp", "wp", "wp", "wp", "wp", "wp", "wp",
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        "bp", "bp", "bp", "bp", "bp", "bp", "bp", "bp",
        "br", "bn", "bb", "bq", "bk", "bb", "bn", "br"
      ]
    }
  end

  @spec update_board(%__MODULE__{}, integer(), binary(), integer()) :: %__MODULE__{}
  def update_board(board, square_one, piece_one, square_two) do
    %{
      board |
      pieces:
        board.pieces
        |> List.update_at(square_one, fn _ -> nil end)
        |> List.update_at(square_two, fn _ -> piece_one end)
    }
  end

  @spec check?(%__MODULE__{}, binary()) :: boolean()
  def check?(%__MODULE__{} = board, king_color) do
    king_square = Enum.find_index(board.pieces, fn p -> p == (king_color <> "k") end)

    board.pieces
    |> Enum.with_index()
    |> Enum.filter(fn {p, s} ->
      case king_color == "w" do
        true -> String.at(p, 0) == "b"

        false -> String.at(p, 0) == "w"
      end
    end)
    |> Enum.any?(fn {p, s} ->
      board
      |> can_move?(s, p, king_square, king_color <> "k")
    end)
  end

  @spec checkmate?(%__MODULE__{}, binary()) :: boolean()
  def checkmate?(board, king_color) do
    board.pieces
    |> Enum.with_index()
    |> Enum.filter(fn {p, _} ->
      String.at(p, 0) == king_color
    end)
    |> Enum.all?(fn {p, s} ->
      0..63
      |> Enum.all?(fn st ->
        move(board, s, p, st, Enum.at(board.pieces, st)).pieces
        == board.pieces
      end)
    end)
  end

  @spec move(%__MODULE__{}, integer(), binary(), integer(), binary()) :: %__MODULE__{}
  def move(%__MODULE__{} = board, square_one, piece_one, square_two, piece_two) do
    (
      can_move?(board, square_one, piece_one, square_two, piece_two)
      && not check?(
        board
        |> update_board(square_one, piece_one, square_two),
        String.at(piece_one, 0)
      )
    )
    |> case do
      true -> update_board(board, square_one, piece_one, square_two)

      false -> board
    end
  end

  def can_move?(%__MODULE__{} = board, square_one, "w" <> _rest, square_two, "w" <> _), do: false

  def can_move?(%__MODULE__{} = board, square_one, "b" <> _rest, square_two, "b" <> _), do: false

  def can_move?(%__MODULE__{} = board, square_one, "wp", square_two, nil) do
    square_two > square_one
    && can_move_pawn?(square_one, square_two, 1)
  end

  def can_move?(%__MODULE__{} = board, square_one, "bp", square_two, nil) do
    square_one > square_two
    && can_move_pawn?(square_one, square_two, 6)
  end

  def can_move?(%__MODULE__{} = board, square_one, "wp", square_two, _),
    do: can_pawn_attack?(square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "bp", square_two, _),
    do: can_pawn_attack?(square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "wr", square_two, _),
    do: can_move_rook?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "br", square_two, _),
    do: can_move_rook?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "wb", square_two, _),
    do: can_move_bishop?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "bb", square_two, _),
    do: can_move_bishop?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "wn", square_two, _),
    do: can_move_knight?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "bn", square_two, _),
    do: can_move_knight?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "wq", square_two, _),
    do: can_move_queen?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "bq", square_two, _),
    do: can_move_queen?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "wk", square_two, _),
    do: can_move_king?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, "bk", square_two, _),
    do: can_move_king?(board, square_one, square_two)

  def can_move?(%__MODULE__{} = board, square_one, piece_one, square_two, piece_two), do: false

  def can_move_pawn?(square_one, square_two, start_row) do
    (
      div(square_one, 8) == start_row
      && (
        abs(square_one - square_two) == 8
        || abs(square_one - square_two) == 16
      )
    )
    || abs(square_one - square_two) == 8
  end

  def can_pawn_attack?(square_one, square_two) do
    abs(square_one - square_two) == 7
    || abs(square_one - square_two) == 9
  end

  def can_move_rook?(%__MODULE__{} = board, square_one, square_two) do
    (
      same_rank?(square_one, square_two)
      || same_file?(square_one, square_two)
    ) && no_piece_in_line?(board, square_one, square_two)
  end

  def can_move_bishop?(%__MODULE__{} = board, square_one, square_two) do
    diagonal_move?(square_one, square_two)
    && no_piece_on_diagonal?(board, square_one, square_two)
    && not bishop_wrap?(square_one, square_two)
  end

  def can_move_knight?(%__MODULE__{} = board, square_one, square_two) do
    abs(square_one - square_two) < 18
    && (
      rem(abs(square_one - square_two), 6) == 0
      || rem(abs(square_one - square_two), 10) == 0
      || rem(abs(square_one - square_two), 15) == 0
      || rem(abs(square_one - square_two), 17) == 0
    )
    && not knight_wrap?(square_one, square_two)
  end

  def can_move_queen?(%__MODULE__{} = board, square_one, square_two) do
    can_move_bishop?(board, square_one, square_two)
    || can_move_rook?(board, square_one, square_two)
  end

  def can_move_king?(%__MODULE__{} = board, square_one, square_two) do
    (
      abs(square_one - square_two) == 1
      || abs(square_one - square_two) == 7
      || abs(square_one - square_two) == 8
      || abs(square_one - square_two) == 9
    )
    && not file_wrap?(square_one, square_two)
  end

  def same_rank?(square_one, square_two),
    do: div(square_two, 8) == div(square_one, 8)

  def same_file?(square_one, square_two),
    do: rem(abs(square_two - square_one), 8) == 0

  def diagonal_move?(square_one, square_two) do
    rem(abs(square_one - square_two), 9) == 0
    || rem(abs(square_one - square_two), 7) == 0
  end

  def no_piece_in_line?(%__MODULE__{} = board, square_one, square_two) do
    (abs(square_one - square_two) == 1)
    || (abs(square_one - square_two) == 8)
    || (
      case same_rank?(square_one, square_two) do
        true ->
          case square_one > square_two do
            true -> (square_one - 1)..(square_two + 1)

            false -> (square_one + 1)..(square_two - 1)
          end
          |> Enum.all?(fn n ->
            board.pieces
            |> Enum.at(n)
            |> case do
              nil -> true

              _ -> false
            end
          end)

        false ->
          case square_one > square_two do
            true ->
              board
              |> square_has_piece?(square_one, square_two, 8, squares_away(:below, 8))

            false ->
              board
              |> square_has_piece?(square_one, square_two, 8, squares_away(:above, 8))
          end
      end
    )
  end

  def no_piece_on_diagonal?(%__MODULE__{} = board, square_one, square_two) do
    (abs(square_one - square_two) == 9)
    || (abs(square_one - square_two) == 7)
    || (
      case rem(abs(square_one - square_two), 9) == 0 do
        true ->
          case square_one > square_two do
            true ->
              board
              |> square_has_piece?(square_one, square_two, 9, squares_away(:below, 9))

            false ->
              board
              |> square_has_piece?(square_one, square_two, 9, squares_away(:above, 9))
          end

        false ->
          case square_one > square_two do
            true ->
              board
              |> square_has_piece?(square_one, square_two, 7, squares_away(:below, 7))

            false ->
              board
              |> square_has_piece?(square_one, square_two, 7, squares_away(:above, 7))
          end
      end
    )
  end

  def bishop_wrap?(square_one, square_two) do
    case square_two > square_one do
      true ->
        case rem(abs(square_one - square_two), 9) == 0 do
          true -> rem(square_two, 8) < rem(square_one, 8)

          false -> rem(square_two, 8) > rem(square_one, 8)
        end

      false ->
        case rem(abs(square_one - square_two), 9) == 0 do
          true -> rem(square_two, 8) > rem(square_one, 8)

          false -> rem(square_two, 8) < rem(square_one, 8)
        end
    end
  end

  def knight_wrap?(square_one, square_two) do
    file_wrap?(square_one, square_two)
    || (
      rem(square_two, 8) == 7 && rem(square_one, 8) == 1
      || rem(square_two, 8) == 1 && rem(square_one, 8) == 7
      || rem(square_two, 8) == 7 && rem(square_one, 8) == 3
      || rem(square_two, 8) == 3 && rem(square_one, 8) == 7
      || rem(square_two, 8) == 6 && rem(square_one, 8) == 0
      || rem(square_two, 8) == 0 && rem(square_one, 8) == 6
      || rem(square_two, 8) == 6 && rem(square_one, 8) == 2
      || rem(square_two, 8) == 2 && rem(square_one, 8) == 6
    )
  end

  def file_wrap?(square_one, square_two) do
    rem(square_two, 8) == 7 && rem(square_one, 8) == 0
    || rem(square_two, 8) == 0 && rem(square_one, 8) == 7
  end

  def square_has_piece?(%__MODULE__{} = board, square_one, square_two, squares_away, fun) do
    0..(div(abs(square_one - square_two), squares_away) - 2)
    |> Enum.all?(fn n ->
      board.pieces
      |> Enum.at(fun.(square_one, n))
      |> case do
        nil -> true

        _ -> false
      end
    end)
  end

  def squares_away(:below, squares), do: fn s, n -> s - (squares * (n + 1)) end

  def squares_away(:above, squares), do: fn s, n -> s + (squares * (n + 1)) end
end
