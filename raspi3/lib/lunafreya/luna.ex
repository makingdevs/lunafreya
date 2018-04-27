defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def think(%Raw{} = data) do
    GenServer.cast(__MODULE__, {:think, data})
  end

  def handle_cast({:think, %Raw{time: time} = data}, state) do
    case {rem(time.minute, 5), time.second} do
      {0, 0} ->
        url = see_what_happens()
        send Raspi3.Slack, {:message, Raw.summary(data), "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      _ ->
        :ok
    end
    {:noreply, state}
  end

  def see_what_happens() do
    Picam.set_size(1920, 0)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    Raspi3.S3.store(Path.join(System.tmp_dir!, filename))
    Raspi3.S3.url(filename)
  end

end
