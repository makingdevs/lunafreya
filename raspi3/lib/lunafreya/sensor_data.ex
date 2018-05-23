defmodule Raspi3.SensorData do
  use GenServer
  alias Raspi3.Raw
  require Logger

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
    case get_data.() do
      {:ok, data} ->
        raw = Raw.new(data)
        Logger.info "#{inspect raw}"
        raw |> act(state)
        {:noreply, [raw | state]}

      {:error, _} ->
        Logger.error "Error getting data"
        {:noreply, state}

    end
  end

  def handle_call({:summary}, _from, state) do
    result = state |>  Enum.filter(fn(%Raw{distance: distance}) -> distance > 0  end)
    {:reply, result, state}
  end

  # Validar la ejecución de `think` cuando raw.distance es > 0
  def act(%Raw{distance: distance}, state) when distance > 0 do
    data_for_last_seconds =
      state
      |> Enum.filter(fn(%Raw{distance: distance}) -> distance > 0  end)
      |> Enum.take(30)
    Raspi3.Luna.think(raw, data_for_last_seconds)
  end

  def act(_, _) do
    :ok
  end

end

