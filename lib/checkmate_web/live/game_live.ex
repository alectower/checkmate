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
  def handle_event("move", %{"piece" => square_piece} = params, %{assigns: %{selected: selected, board: board}} = socket) do
    IO.inspect params
    [square, piece] = String.split(square_piece, ":")

    case is_nil(selected) do
      true -> {:noreply, assign(socket, selected: square_piece)}

      false ->
        {
          :noreply,
          assign(
            socket,
            board: Board.move(board, selected, square_piece),
            selected: nil
          )
        }
    end
  end
end
