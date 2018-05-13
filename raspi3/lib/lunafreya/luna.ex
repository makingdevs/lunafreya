defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, {:dont_record}}
  end

  def think(%Raw{} = data, data_for_last_seconds) do
    GenServer.cast(__MODULE__, {:think, data, data_for_last_seconds})
  end

  def handle_cast({:think, %Raw{} = data, data_for_last_seconds}, state) do
    {:noreply, state}
  end

  def handle_info({:picture_taked}, state) do
    {:noreply, state}
  end

  def take_the_picture() do
    Process.send_after(self(), {:picture_taked}, 3 *  1000)
  end

  def see_what_happens() do
    Picam.set_size(640, 0)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    @uploader.store(Path.join(System.tmp_dir!, filename))
    @uploader.url(filename)
  end

end
