defmodule LiveviewRepro.Repo do
  use Ecto.Repo,
    otp_app: :liveview_repro,
    adapter: Ecto.Adapters.Postgres
end
