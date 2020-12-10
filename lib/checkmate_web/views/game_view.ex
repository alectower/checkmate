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

  def board_piece(board, rank, file) do
    board
    |> Map.get(
      "#{file}#{rank}"
      |> String.to_existing_atom()
    )
    |> case do
      nil -> ""
      p -> p
    end
  end

  def file_id(rank, file) do
    "#{file}#{rank}"
  end

  def piece_id(board, rank, file) do
    "#{file}#{rank}:" <> board_piece(board, rank, file)
  end

  def selected_class(selected, piece_id) do
    case selected == piece_id do
      true -> "selected"
      false -> ""
    end
  end
end
