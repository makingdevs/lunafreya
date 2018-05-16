defmodule Raspi3.Luna.EyesServer do

  use GenServer

  @uploader Application.get_env(:raspi3, :uploader)
  @base_dir System.tmp_dir!
  @frames 60

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
    process = spawn(__MODULE__, :see_what_happens, [])
    {:reply, process, state}
  end

  def see_what_happens() do
    Picam.set_size(640, 480)

    filenames  = for n <- (1..@frames),
      do: "luna_#{i}" <> ".jpg"

    files = (1..@frames)
            |> Enum.map(fn i ->
              filename = "luna_#{i}" <> ".jpg"
              capture_frame_with_name(filename)
              filename
            end)


    timestamp = :os.system_time
    [video_command | video_args] = "ffmpeg -f image2 -i " <> Path.join(@base_dir, "luna_%d.jpg") <> " " <> Path.join(@base_dir, "video.avi")
                                   |> String.split(" ")

    video_command |> System.cmd(video_args)

    gifname = "luna_#{timestamp}.gif"
    [gif_command | gif_args] = "ffmpeg -i " <> Path.join(@base_dir, "video.avi") <> " -pix_fmt rgb24 " <> Path.join(@base_dir, gifname)
                               |> String.split(" ")
    gif_command |> System.cmd(gif_args)

    File.rm(Path.join(@base_dir, "video.avi"))
    files |> Enum.each(fn file -> File.rm(Path.join(System.tmp_dir!, file)) end)

    @uploader.store(Path.join(System.tmp_dir!, gifname))
    url = @uploader.url(gifname)
    send Raspi3.Slack, {:message, "#{url}", "#iot"}

  end

  def capture_frame_with_name(filename) do
    File.write!(Path.join(@base_dir, filename), Picam.next_frame)
  end

end
