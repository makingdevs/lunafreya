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
    {:ok, data} = get_data.()
    raw = Raw.new(data)
    avg_status = state |> Enum.take(30)
    Raspi3.Luna.think(raw, avg_status)
    {:noreply, [raw | state]}
  end

  def handle_call({:summary}, _from, state) do
    {:reply, state, state}
  end
end

