defmodule TelegramNotes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TelegramNotes.Repo,
      # Start the Telemetry supervisor
      TelegramNotesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TelegramNotes.PubSub},
      # Start the Endpoint (http/https)
      TelegramNotesWeb.Endpoint,
      # Start a worker by calling: TelegramNotes.Worker.start_link(arg)
      # {TelegramNotes.Worker, arg}
      TelegramNotes.Telegram
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TelegramNotes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TelegramNotesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
