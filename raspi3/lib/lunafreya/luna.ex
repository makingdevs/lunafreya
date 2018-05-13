defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw
  alias Raspi3.Luna.Eyes

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, {:busy}}
  end

  def think(%Raw{} = data, data_for_last_seconds) do
    GenServer.cast(__MODULE__, {:think, data, data_for_last_seconds})
  end

  def handle_cast({:think, %Raw{} = data, data_for_last_seconds}, state) do
    check_what_is_seeing(data, data_for_last_seconds, state)
    {:noreply, state}
  end

  def handle_info({:make_busy}, state) do
    {:noreply, {:busy}}
  end

  def handle_info({:make_free}, state) do
    {:noreply, {:not_busy}}
  end

  def check_what_is_seeing(%Raw{distance: distance} = data, data_for_last_seconds, {eyes_watching}) do
    [temperature: [mean: mean_t, median: median_t], distance: _, light: _, moving: _] = Raw.statistics(data_for_last_seconds)
    case Eyes.preserve_the_moment({distance, median_t}, eyes_watching) do
      :record_image ->
        Process.send_after(self(), {:make_busy}, 1)
        IO.puts "Start recording image"
        :timer.sleep(3000)
        IO.puts "Ends recording image"
        Process.send_after(self(), {:make_free}, 1)
      :dont_record ->
        IO.puts "DONT record"
    end
  end

  def see_what_happens() do
    Picam.set_size(640, 0)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    @uploader.store(Path.join(System.tmp_dir!, filename))
    @uploader.url(filename)
  end

end
