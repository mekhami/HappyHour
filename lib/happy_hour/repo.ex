defmodule HappyHour.Repo do
  use Ecto.Repo,
    otp_app: :happy_hour,
    adapter: Ecto.Adapters.Postgres
end
