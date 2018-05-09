defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, [camera_busy: false]}
  end

  def think(%Raw{} = data, data_for_last_seconds) do
    GenServer.cast(__MODULE__, {:think, data, data_for_last_seconds})
  end

  def handle_cast({:think, %Raw{} = data, data_for_last_seconds}, state) do
    data
    stats = Raw.statistics(data_for_last_seconds)
    # TODO: Compare the values
    # Take the picture and block the camera, maybe a message
    # Block the camera while picture
    # Unblock after the picture

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
