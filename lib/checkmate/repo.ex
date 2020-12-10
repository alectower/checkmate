defmodule Checkmate.Repo do
  use Ecto.Repo,
    otp_app: :checkmate,
    adapter: Ecto.Adapters.Postgres
end
