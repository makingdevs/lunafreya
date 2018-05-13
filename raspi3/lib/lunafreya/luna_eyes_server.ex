defmodule Raspi3.Luna.EyesServer do

  use GenServer

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  def open_the_eyes() do
    GenServer.call(__MODULE__, {:open_the_eyes})
  end

  # def handle_cast(message, state) do
  #   {:noreply, state}
  # end

  def handle_call({:open_the_eyes}, _from, state) do
    url = see_what_happens()
    {:reply, url, state}
  end

  def see_what_happens() do
    Picam.set_size(640, 480)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    @uploader.store(Path.join(System.tmp_dir!, filename))
    @uploader.url(filename)
  end

end
