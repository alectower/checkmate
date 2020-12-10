defmodule Checkmate.Board do
  defstruct [
    :a1, :a2, :a3, :a4, :a5, :a6, :a7, :a8,
    :b1, :b2, :b3, :b4, :b5, :b6, :b7, :b8,
    :c1, :c2, :c3, :c4, :c5, :c6, :c7, :c8,
    :d1, :d2, :d3, :d4, :d5, :d6, :d7, :d8,
    :e1, :e2, :e3, :e4, :e5, :e6, :e7, :e8,
    :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8,
    :g1, :g2, :g3, :g4, :g5, :g6, :g7, :g8,
    :h1, :h2, :h3, :h4, :h5, :h6, :h7, :h8
  ]

  def init do
    %__MODULE__{
      a1: "wr", a2: "wp", a3: nil, a4: nil, a5: nil, a6: nil, a7: "bp", a8: "br",
      b1: "wn", b2: "wp", b3: nil, b4: nil, b5: nil, b6: nil, b7: "bp", b8: "bn",
      c1: "wb", c2: "wp", c3: nil, c4: nil, c5: nil, c6: nil, c7: "bp", c8: "bb",
      d1: "wq", d2: "wp", d3: nil, d4: nil, d5: nil, d6: nil, d7: "bp", d8: "bq",
      e1: "wk", e2: "wp", e3: nil, e4: nil, e5: nil, e6: nil, e7: "bp", e8: "bk",
      f1: "wb", f2: "wp", f3: nil, f4: nil, f5: nil, f6: nil, f7: "bp", f8: "bb",
      g1: "wn", g2: "wp", g3: nil, g4: nil, g5: nil, g6: nil, g7: "bp", g8: "bn",
      h1: "wr", h2: "wp", h3: nil, h4: nil, h5: nil, h6: nil, h7: "bp", h8: "br"
    }
  end

  def move(%__MODULE__{} = board, square_piece_one, square_piece_two) do
    [square_one, piece_one] = String.split(square_piece_one, ":")
    [square_two, piece_two] = String.split(square_piece_two, ":")

    case Map.get(board, square_two |> String.to_existing_atom()) do
      nil -> update_board(board, square_one, piece_one, square_two)

      piece ->
        case can_take_piece(piece_one, piece) do
          true -> update_board(board, square_one, piece_one, square_two)

          false -> board
        end
    end
  end

  def can_take_piece(piece_one, piece_two), do: true

  def update_board(board, square_one, piece_one, square_two) do
    board
    |> Map.put(
      square_one
      |> String.to_existing_atom(),
      nil
    )
    |> Map.put(
      square_two
      |> String.to_existing_atom(),
      piece_one
    )
  end
end
