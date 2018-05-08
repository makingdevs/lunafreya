defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def think(%Raw{} = data, avg_status) do
    GenServer.cast(__MODULE__, {:think, data, avg_status})
  end

  def handle_cast({:think, %Raw{time: time} = data, avg_status}, state) do
    # TODO: Perform the calculation
    data
    avg_status
    state
    {:noreply, state}
  end

  def see_what_happens() do
    Picam.set_size(640, 0)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    @uploader.store(Path.join(System.tmp_dir!, filename))
    @uploader.url(filename)
  end

end
