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

    filenames = for n <- (1..@frames), do: "luna_#{n}" <> ".jpg"

    capture_the_frames_with_names()

    [video_command | video_args] = create_command_for_video()

    video_command |> System.cmd(video_args)

    [gif_command | gif_args] = create_command_for_gif()

    gif_command |> System.cmd(gif_args)

    File.rm(Path.join(@base_dir, "video.avi"))
    files |> Enum.each(fn file -> File.rm(Path.join(System.tmp_dir!, file)) end)

    @uploader.store(Path.join(System.tmp_dir!, gifname))
    url = @uploader.url(gifname)

    send Raspi3.Slack, {:message, "#{url}", "#iot"}

  end

  def capture_frame_with_name(filename) do
    File.write!(Path.join(@base_dir, filename), Picam.next_frame)
    :ok
  end

  def capture_the_frames_with_names(filenames) do
    filenames
    |> Enum.each(fn i -> capture_frame_with_name(filename) end)
  end

  def create_command_for_video() do
    pattern_for_files = Path.join(@base_dir, "luna_%d.jpg")
    video_name = Path.join(@base_dir, "video.avi")
    "ffmpeg -f image2 -i " <> pattern_for_files <> " " <> video_name
    |> String.split(" ")
  end

  def create_command_for_gif() do
    gifname = Path.join(@base_dir, "luna_#{:os.system_time}.gif")
    video_name = Path.join(@base_dir, "video.avi")
    "ffmpeg -i " <> video_name <> " -pix_fmt rgb24 " <> gifname
    |> String.split(" ")
  end

end
