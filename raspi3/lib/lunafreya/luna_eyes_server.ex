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

  def handle_call({:open_the_eyes}, _from, state) do
    url = see_what_happens()
    send Raspi3.Slack, {:message, "#{url}", "#iot"}
    {:reply, url, state}
  end

  def see_what_happens() do
    Picam.set_size(640, 480)

    base_dir = System.tmp_dir!

    files = (1..120)
            |> Enum.map(fn i ->
              # filename = "luna_#{:os.system_time}" <> ".jpg"
              filename = "luna_#{i}" <> ".jpg"
              File.write!(Path.join(basedir, filename), Picam.next_frame)
              filename
            end)


    'ffmpeg -f image2 -i' ++ (baseDir |> String.to_charlist)  ++ ' luna_%d.jpg video.avi'
    'ffmpeg -i video.avi -pix_fmt rgb24 -loop_output 0 out.gif'

    # files |> Enum.each(fn filename -> File.rm(Path.join(System.tmp_dir!, filename)) end)

    IO.puts "Files generated"
    IO.inspect files

    # @uploader.store(Path.join(System.tmp_dir!, filename))
    # @uploader.url(filename)
    "temp"
  end

end
