defmodule Raspi3.Luna do

  use GenServer
  alias Raspi3.Raw

  @uploader Application.get_env(:raspi3, :uploader)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, [eyes_watching: false]}
  end

  def think(%Raw{} = data, data_for_last_seconds) do
    GenServer.cast(__MODULE__, {:think, data, data_for_last_seconds})
  end

  def handle_cast({:think, %Raw{} = data, data_for_last_seconds}, [eyes_watching: eyes_watching] = _state) do
    continue_watching = case eyes_watching do
      true ->
        IO.puts "Eyes busy"
      false ->
        IO.puts "Let's watch"
        stats = Raw.statistics(data_for_last_seconds)
        case stats["distance"][:median] - 50 <= data.distance || data.distance >= stats["distance"][:median] + 50  do
          true ->
            IO.puts "Take the picture"
            IO.puts "#{stats["distance"][:median] - 50} <= #{data.distance} || #{data.distance} >= #{stats["distance"][:median] + 50}"
            take_the_picture()
          false ->
            IO.puts "NO PIC"
            IO.puts "#{stats["distance"][:median] - 50} <= #{data.distance} || #{data.distance} >= #{stats["distance"][:median] + 50}"
        end
    end
    # TODO: Compare the values
    # Take the picture and block the camera, maybe a message
    # Block the camera while picture
    # Unblock after the picture

    {:noreply, [eyes_watching: true]}
  end

	def handle_info({:picture_taked}, _state) do
		{:noreply, [eyes_watching: false]}
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
