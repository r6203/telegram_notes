defmodule TelegramNotes.UnixDate do
  @behaviour Ecto.Type

  def type, do: :integer

  def cast(timestamp) when is_integer(timestamp) do
    # is this ugly?
    case DateTime.from_unix(timestamp) do
      {:ok, _dt} -> {:ok, timestamp}
      {:error, _error} -> :error
    end
  end

  def cast(_), do: :error

  def load(timestamp) when is_integer(timestamp), do: {:ok, timestamp}

  def load(_), do: :error

  def dump(timestamp) when is_integer(timestamp), do: {:ok, timestamp}
  def dump(_), do: :error

  def equal?(term, other), do: term == other
end
