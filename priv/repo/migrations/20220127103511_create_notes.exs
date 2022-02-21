defmodule TelegramNotes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :date, TelegramNotes.UnixDate.type()

      timestamps()
    end

    create table(:text_notes) do
      add :title, :string
      add :body, :text
      add :note_id, references(:notes)

      timestamps()
    end

    create table(:screenshot_notes) do
      add :url, :string
      add :description, :text
      add :desktop_image_path, :string
      add :mobile_image_path, :string
      add :note_id, references(:notes)

      timestamps()
    end
  end
end
