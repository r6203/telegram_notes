defmodule TelegramNotesWeb.NoteLive.Index do
  use TelegramNotesWeb, :live_view

  alias TelegramNotes.Notes
  alias TelegramNotesWeb.Notes.Components.Note

  data note, :any, default: nil

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(TelegramNotes.PubSub, "bot_update")

    {:ok,
     socket
     |> assign(:notes, list_notes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:new_updates, _updates}, socket),
    do: {:noreply, assign(socket, notes: list_notes())}

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, Notes.get_note!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Notes.Note{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notes")

    # |> assign(:note, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, assign(socket, :notes, list_notes())}
  end

  defp list_notes do
    Notes.list_notes()
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="py-12">
      <div class="container">
        <ul class="space-y-8">
          {#for note <- @notes}
            <Note id={note.id} note={note} />
          {/for}
        </ul>
      </div>
    </div>
    """
  end
end
