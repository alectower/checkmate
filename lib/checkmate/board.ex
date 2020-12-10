defmodule Checkmate.Board do
  defstruct [ :pieces ]

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

  def update_board(board, square_one, piece_one, square_two) do
    %{
      board |
      pieces:
        board.pieces
        |> List.update_at(square_one, fn _ -> nil end)
        |> List.update_at(square_two, fn _ -> piece_one end)
    }
  end

  def move(%__MODULE__{} = board, square_one, piece_one, square_two, piece_two) do
    case can_move?(board, square_one, piece_one, square_two, piece_two) do
      true -> update_board(board, square_one, piece_one, square_two)

      false -> board
    end
  end

  def can_move?(board, square_one, "w" <> _rest, square_two, "w" <> _), do: false

  def can_move?(board, square_one, "b" <> _rest, square_two, "b" <> _), do: false

  def can_move?(board, square_one, "wp", square_two, nil) do
    (
      div(square_one, 8) == 1
      && (
        square_two - square_one == 8
        || square_two - square_one == 16
      )
    )
    || square_two - square_one == 8
  end

  def can_move?(board, square_one, "bp", square_two, nil) do
    (
      div(square_one, 8) == 6
      && (
        square_one - square_two == 8
        || square_one - square_two == 16
      )
    )
    || square_one - square_two == 8
  end

  def can_move?(board, square_one, "wp", square_two, _) do
    square_two - square_one == 7
    || square_two - square_one == 9
  end

  def can_move?(board, square_one, "bp", square_two, _) do
    square_one - square_two == 7
    || square_one - square_two == 9
  end

  def can_move?(board, square_one, "wr", square_two, _),
    do: can_move_rook?(board, square_one, square_two)

  def can_move?(board, square_one, "br", square_two, _),
    do: can_move_rook?(board, square_one, square_two)

  def can_move_rook?(board, square_one, square_two) do
    (
      same_rank?(square_one, square_two)
      || same_file?(square_one, square_two)
    ) && no_piece_in_line?(board, square_one, square_two)
  end

  def can_move?(board, square_one, piece_one, square_two, piece_two), do: false

  def same_rank?(square_one, square_two),
    do: div(square_two, 8) == div(square_one, 8)

  def same_file?(square_one, square_two),
    do: rem(abs(square_two - square_one), 8) == 0

  def no_piece_in_line?(board, square_one, square_two) do
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
              |> file_has_piece?(square_one, square_two, tiles_away(:below))

            false ->
              board
              |> file_has_piece?(square_one, square_two, tiles_away(:above))
          end
      end
    )
  end

  def file_has_piece?(board, square_one, square_two, fun) do
    0..(div(abs(square_one - square_two), 8) - 2)
    |> Enum.all?(fn n ->
      board.pieces
      |> Enum.at(fun.(square_one, n))
      |> case do
        nil -> true

        _ -> false
      end
    end)
  end

  def tiles_away(:below), do: fn s, n -> s - (8 * (n + 1)) end

  def tiles_away(:above), do: fn s, n -> s + (8 * (n + 1)) end
end
