defmodule CheckmateWeb.GameLive do
  use CheckmateWeb, :live_view

  alias CheckmateWeb.GameView
  alias Checkmate.Board

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(
        board: Board.init(),
        selected: nil,
        turn: :white,
        moves: [],
        check: false
      )
    }
  end

  def render(assigns),
    do: GameView.render("game_live.html", assigns)

  @impl true
  def handle_event("move", %{"square" => square, "piece" => piece} = params, %{assigns: %{selected: selected, board: board, turn: turn, moves: moves, check: check}} = socket) do
    cond do
      is_nil(selected) && String.at(to_string(turn), 0) == String.at(piece, 0) ->
        {:noreply, assign(socket, selected: String.to_integer(square))}

      is_nil(selected) -> {:noreply, socket}

      true ->
        new_board =
          board
          |> Board.move(
            selected,
            Enum.at(board.pieces, selected),
            String.to_integer(square),
            Enum.at(board.pieces, String.to_integer(square))
          )

        {
          :noreply,
          socket
          |> assign(
            selected: nil,
            board: new_board,
            moves:
              case new_board.pieces == board.pieces do
                true -> moves

                false ->
                  moves ++ [
                    GameView.move_notation(
                      selected,
                      Enum.at(board.pieces, selected),
                      String.to_integer(square),
                      Enum.at(board.pieces, String.to_integer(square))
                    )
                  ]
              end,
            turn: case new_board.pieces == board.pieces do
              true -> turn

              false -> if turn == :white do :black else :white end
            end,
            check:
              case new_board.pieces == board.pieces do
                true -> check

                false -> Board.check?(new_board, if turn == :white do "b" else "w" end)
              end
          )
        }
    end
  end

  @impl true
  def handle_event("move", %{"square" => square} = params, %{assigns: %{selected: selected, board: board, turn: turn, moves: moves, check: check}} = socket) do
    case is_nil(selected) do
      true -> {:noreply, assign(socket, selected: nil)}

      false ->
        new_board =
          board
          |> Board.move(
            selected,
            Enum.at(board.pieces, selected),
            String.to_integer(square),
            Enum.at(board.pieces, String.to_integer(square))
          )

        {
          :noreply,
          socket
          |> assign(
            selected: nil,
            board: new_board,
            moves:
              case new_board.pieces == board.pieces do
                true -> moves

                false ->
                  moves ++ [
                    GameView.move_notation(
                      selected,
                      Enum.at(board.pieces, selected),
                      String.to_integer(square),
                      Enum.at(board.pieces, String.to_integer(square))
                    )
                  ]
              end,
            turn:
              case new_board.pieces == board.pieces do
                true -> turn

                false -> if turn == :white do :black else :white end
              end,
            check:
              case new_board.pieces == board.pieces do
                true -> check

                false -> Board.check?(new_board, if turn == :white do "b" else "w" end)
              end
          )
        }
    end
  end
end
