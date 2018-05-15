defmodule Raspi3.SensorData do
  use GenServer
  alias Raspi3.Raw

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def write_info(get_data) do
    GenServer.cast(__MODULE__, {:write, get_data})
  end

  def timeseries() do
    GenServer.call(__MODULE__, {:summary})
  end

  def handle_cast({:write, get_data}, state) do
    case {result, data} = get_data.() do
      {:ok, data} ->
        raw = Raw.new(data)
        data_for_last_seconds =
          state
          |> Enum.filter(fn(%Raw{distance: distance}) -> distance > 0  end)
          |> Enum.take(30)
        Raspi3.Luna.think(raw, data_for_last_seconds)
        {:noreply, [raw | state]}

      {:error, _} ->
        IO.puts "Error getting data"
        {:noreply, state}

    end
  end

  def handle_call({:summary}, _from, state) do
    {:reply, state, state}
  end
end

