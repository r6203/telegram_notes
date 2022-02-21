defmodule TelegramNotes do
  @moduledoc """
  TelegramNotes keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def foo() do
    Application.fetch_env!(:telegram_notes, :telegram_token)
  end
end
