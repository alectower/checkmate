defmodule CheckmateWeb.GameLive do
  use CheckmateWeb, :live_view

  alias CheckmateWeb.GameView
  alias Checkmate.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: Board.init(), selected: nil)}
  end

  def render(assigns),
    do: GameView.render("game_live.html", assigns)

  @impl true
  def handle_event("move", %{"square" => square, "piece" => piece} = params, %{assigns: %{selected: selected, board: board}} = socket) do
    case is_nil(selected) do
      true -> {:noreply, assign(socket, selected: String.to_integer(square))}

      false ->
        {
          :noreply,
          socket
          |> assign(
            selected: nil,
            board:
              board
              |> Board.move(
                selected,
                Enum.at(board.pieces, selected),
                String.to_integer(square),
                Enum.at(board.pieces, String.to_integer(square))
              )
          )
        }
    end
  end

  def handle_event("move", %{"square" => square} = params, %{assigns: %{selected: selected, board: board}} = socket) do
    case is_nil(selected) do
      true -> {:noreply, assign(socket, selected: nil)}

      false ->
        {
          :noreply,
          socket
          |> assign(
            selected: nil,
            board:
              board
              |> Board.move(
                selected,
                Enum.at(board.pieces, selected),
                String.to_integer(square),
                Enum.at(board.pieces, String.to_integer(square))
              )
          )
        }
    end
  end
end
