defmodule Raspi3.Luna.EyesServer do

  use GenServer
  require Logger

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
    Logger.debug "Opening the eyes!"
    result = Task.start fn ->
      Logger.debug "Starting a task"
      see_what_happens()
      Logger.debug "Finishing the task"
    end
    {:reply, result, state}
  end

  def see_what_happens() do
    Picam.set_size(640, 480)

    filenames = for n <- (1..@frames), do: "luna_#{n}" <> ".jpg"

    filenames |> capture_the_frames_with_names()

    [video_command | video_args] = create_command_for_video()
    {_, _} = System.cmd(video_command, video_args, [stderr_to_stdout: true])

    { gifname, [gif_command | gif_args]} = create_command_for_gif()
    {_, _} = System.cmd(gif_command, gif_args, [stderr_to_stdout: true])

    upload_file(gifname)

    File.rm(Path.join(@base_dir, "video.avi"))
    filenames |> Enum.each(fn file -> File.rm(Path.join(System.tmp_dir!, file)) end)

  end

  def capture_frame_with_name(filename) do
    File.write!(Path.join(@base_dir, filename), Picam.next_frame)
  end

  def capture_the_frames_with_names(filenames) do
    filenames
    |> Enum.each(&(capture_frame_with_name(&1)))
  end

  def create_command_for_video() do
    pattern_for_files = Path.join(@base_dir, "luna_%d.jpg")
    video_name = Path.join(@base_dir, "video.avi")
    "ffmpeg -f image2 -i " <> pattern_for_files <> " " <> video_name
    |> String.split(" ")
  end

  def create_command_for_gif() do
    gifname = "luna_#{:os.system_time}.gif"
    gifpath = Path.join(@base_dir, gifname)
    video_name = Path.join(@base_dir, "video.avi")
    command = "ffmpeg -i " <> video_name <> " -pix_fmt rgb24 " <> gifpath
    |> String.split(" ")
    {gifname, command}
  end

  def upload_file(gifname) do
    case @uploader.store(Path.join(System.tmp_dir!, gifname)) do
      {:ok, filename} ->
        url = @uploader.url(filename)
        send Raspi3.Slack, {:message, "#{url}", "#iot"}
      message ->
        msg = "Can't upload image #{inspect message}"
        send Raspi3.Slack, {:message, msg, "#iot"}
    end
  end

end
