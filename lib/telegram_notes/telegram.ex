defmodule TelegramNotes.Telegram do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    state = %{me: nil, last_seen: 0}

    {:ok, state, {:continue, :get_me}}
  end

  @impl true
  def handle_continue(:get_me, state) do
    me =
      case Nadia.get_me() do
        {:ok, %Nadia.Model.User{username: username} = me} ->
          Logger.info("Telegram Bot successfully initialized: #{username}")

          get_updates()

          me

        {:error, error} ->
          Logger.error("Telegram Bot failed to initialize: #{IO.inspect(error)}")

          :error
      end

    {:noreply, %{state | me: me}}
  end

  @impl true
  def handle_info(:get_updates, %{last_seen: last_seen} = state) do
    state =
      case Nadia.get_updates(offset: last_seen + 1) do
        {:ok, []} ->
          state

        {:ok, update} ->
          last_seen = process_updates(update)

          %{state | last_seen: last_seen}

        {:error, error} ->
          Logger.error("Error getting Telegram updates #{inspect(error)}")
          Process.sleep(2_000)

          state
      end

    get_updates()

    {:noreply, state}
  end

  defp get_updates() do
    Process.send_after(self(), :get_updates, 0)
  end

  defp process_updates(updates) do
    last_seen =
      updates
      |> Stream.each(&process_update/1)
      |> Stream.map(fn update -> update.update_id end)
      |> Enum.max(fn -> 0 end)

    broadcast({:new_updates, updates})

    last_seen
  end

  defp process_update(%Nadia.Model.Update{message: %{text: text}} = update)
       when not is_nil(text) do
    if is_screenshot_message?(text) do
      process_screenshot_update(update)
    else
      process_text_update(update)
    end
  end

  defp process_update(update) do
    Logger.info("Received unknown update: #{inspect(update)}")

    update
  end

  defp process_text_update(%Nadia.Model.Update{message: %{date: date, text: text}} = update) do
    Logger.info("Processing text message: #{text}")

    [title | tail] = String.split(text, "\n")

    {:ok, _note} =
      TelegramNotes.Notes.create_note(%{
        title: title,
        body: tail |> Enum.join(" "),
        # TODO check timezone
        date: date
      })

    update
  end

  defp process_screenshot_update(%Nadia.Model.Update{message: %{date: date, text: url}} = update) do
    Logger.info("Processing screenshot message: #{url}")

    TelegramNotes.Screenshot.make_screenshot(url)

    update
  end

  defp is_screenshot_message?(text) do
    (String.starts_with?(text, "http://") || String.starts_with?(text, "https://")) &&
      not String.contains?(text, "youtu.be") && not String.contains?(text, "youtube.com")
  end

  defp broadcast(details),
    do: Phoenix.PubSub.broadcast!(TelegramNotes.PubSub, "bot_update", details)
end
