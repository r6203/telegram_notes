defmodule TelegramNotes.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TelegramNotes.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body",
        date: DateTime.utc_now() |> DateTime.to_unix()
      })
      |> TelegramNotes.Notes.create_note()

    note
  end
end
