defmodule TelegramNotesWeb.Notes.Components.Note do
  use Surface.LiveComponent

  alias TelegramNotesWeb.Router.Helpers, as: Routes
  alias Surface.Components.LivePatch

  prop note, :any

  def render(assigns) do
    ~F"""
    <li class="flex flex-col p-6 bg-white shadow-box rounded-lg">
      <div class="flex flex-wrap">
        <h2 class="flex-1 font-bold sm:text-lg">
          {@note.title}
        </h2>
        <div class="flex items-center space-x-3">
          <LivePatch to={Routes.note_index_path(@socket, :edit, @note.id)}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6 text-gray-700 hover:text-gray-900 transition"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
              />
            </svg>
          </LivePatch>
          <button phx-click="delete" phx-value-id={@note.id}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6 text-red-600 hover:text-red-800 transition"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
              />
            </svg>
          </button>
        </div>
      </div>
      <p :if={@note.body} class="mt-3 text-gray-700">
        {@note.body}
      </p>
      <p class="mt-3 text-gray-500 text-sm self-end">
        {timestamp_to_string(@note.date)}
      </p>
    </li>
    """
  end

  defp timestamp_to_string(timestamp) do
    timestamp
    |> DateTime.from_unix!()
    # TODO replace hardcoded timezone
    |> Timex.to_datetime("Europe/Berlin")
    |> Timex.format!("{D}.{M}.{YY} {h24}:{m}")
  end
end
