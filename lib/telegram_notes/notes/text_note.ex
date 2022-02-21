defmodule TelegramNotes.Notes.TextNote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "text_notes" do
    field :title, :string
    field :body, :string
    belongs_to :note, TelegramNotes.Notes.Note

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :body])
    |> validate_required([:title])
  end
end
