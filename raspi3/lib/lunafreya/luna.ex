defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw
  alias Raspi3.Luna.Eyes
  alias Raspi3.Luna.EyesServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, {:ready_for_act}}
  end

  def think(%Raw{} = data, data_for_last_seconds) do
    GenServer.cast(__MODULE__, {:think, data, data_for_last_seconds})
  end

  def current_status() do
    GenServer.call(__MODULE__, {:current_status})
  end

  def handle_cast({:think, %Raw{} = data, data_for_last_seconds}, state) do
    how_is_luna = check_what_is_seeing(data, data_for_last_seconds, state)
    {:noreply, { how_is_luna }}
  end

  def handle_call({:current_status}, _from, state) do
    {:reply, state, state}
  end

  def check_what_is_seeing(%Raw{distance: distance}, data_for_last_seconds, {how_is_luna}) do
    [temperature: _, distance: [mean: mean_d, median: median_d], light: _, moving: _] = Raw.statistics(data_for_last_seconds)

    # TODO: This logic needs a test
    case how_is_luna do
      :ready_for_act ->
        case Eyes.preserve_the_moment({distance, median_d}, how_is_luna) do
          :record_image ->
            EyesServer.open_the_eyes()
            :in_recovering
          :dont_record ->
            :ready_for_act
        end
      :in_recovering ->
        case mean_d == median_d do
          true -> :ready_for_act
          false -> :in_recovering
        end
    end

  end

end
