defmodule TelegramNotes.Repo do
  use Ecto.Repo,
    otp_app: :telegram_notes,
    adapter: Ecto.Adapters.SQLite3
end
