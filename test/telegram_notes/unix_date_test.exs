defmodule TelegramNotes.UnixDateTest do
  use TelegramNotes.DataCase

  alias TelegramNotes.UnixDate

  test "cast" do
    dt = DateTime.utc_now()
    dt_unix = DateTime.to_unix(dt)

    assert UnixDate.cast(dt_unix) == {:ok, dt_unix}
  end

  test "load" do
    dt_unix = DateTime.utc_now() |> DateTime.to_unix()

    assert UnixDate.load(dt_unix) == {:ok, dt_unix}
  end

  test "dump" do
    dt_unix = DateTime.utc_now() |> DateTime.to_unix()

    assert UnixDate.dump(dt_unix) == {:ok, dt_unix}
  end

  test "equal" do
    dt1 = 1_643_496_163
    dt2 = 1_643_496_163

    assert UnixDate.equal?(dt1, dt2)
    assert not UnixDate.equal?(DateTime.utc_now() |> DateTime.to_unix(), dt1)
  end
end
