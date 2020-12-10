defmodule CheckmateWeb.GameView do
  use CheckmateWeb, :view

  def piece_display("wp"), do: "♙"
  def piece_display("wr"), do: "♖"
  def piece_display("wn"), do: "♘"
  def piece_display("wb"), do: "♗"
  def piece_display("wq"), do: "♕"
  def piece_display("wk"), do: "♔"
  def piece_display("bp"), do: "♟︎"
  def piece_display("br"), do: "♜"
  def piece_display("bn"), do: "♞"
  def piece_display("bb"), do: "♝"
  def piece_display("bq"), do: "♛"
  def piece_display("bk"), do: "♚"
  def piece_display(""), do: ""

  def board_piece(board, square) do
    Enum.at(board.pieces, square)
    |> case do
      nil -> ""

      p -> p
    end
  end

  def file_id(rank, file) do
    Integer.to_string(rank*(8)+file-1)
  end

  def piece_id(board, rank, file) do
    file_id(rank, file) <> board_piece(board, piece_position(rank, file))
  end

  def piece_position(rank, file),  do: rank*(8)+file-1

  def selected_class(selected, piece_id) do
    case selected == piece_id do
      true -> "selected"

      false -> ""
    end
  end
end
