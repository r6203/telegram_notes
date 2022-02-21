defmodule TelegramNotes.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :date, TelegramNotes.UnixDate
    has_many :text_notes, TelegramNotes.Notes.TextNote

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:date])
    |> validate_required([:date])
  end
end
