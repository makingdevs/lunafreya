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

    filenames |> capture_the_frames_with_names()

    video_command = create_command_for_video()
    video_command |> :os.cmd
    { gifname, gif_command} = create_command_for_gif()
    gif_command |> :os.cmd

    File.rm(Path.join(@base_dir, "video.avi"))
    filenames |> Enum.each(fn file -> File.rm(Path.join(System.tmp_dir!, file)) end)

    @uploader.store(Path.join(System.tmp_dir!, gifname |> List.to_string))
    url = @uploader.url(gifname |> List.to_string)

    send Raspi3.Slack, {:message, "#{url}", "#iot"}

  end

  def capture_frame_with_name(filename) do
    File.write!(Path.join(@base_dir, filename), Picam.next_frame)
    :ok
  end

  def capture_the_frames_with_names(filenames) do
    filenames
    |> Enum.each(&(capture_frame_with_name(&1)))
  end

  def create_command_for_video() do
    pattern_for_files = Path.join(@base_dir, "luna_%d.jpg") |> String.to_charlist
    video_name = Path.join(@base_dir, "video.avi") |> String.to_charlist

    # "ffmpeg -f image2 -i " <> pattern_for_files <> " " <> video_name
    # |> String.split(" ")

    'ffmpeg -f image2 -i ' ++ pattern_for_files ++ ' ' ++ video_name
  end

  def create_command_for_gif() do
    gifname = Path.join(@base_dir, "luna_#{:os.system_time}.gif") |> String.to_charlist
    video_name = Path.join(@base_dir, "video.avi") |> String.to_charlist
    # command = "ffmpeg -i " <> video_name <> " -pix_fmt rgb24 " <> gifname
    # |> String.split(" ")
    command = 'ffmpeg -i ' ++ video_name ++ ' -pix_fmt rgb24 ' ++ gifname
    {gifname, command}
  end

end
