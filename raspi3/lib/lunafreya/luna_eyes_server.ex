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

    files = (1..60)
            |> Enum.map(fn i ->
              filename = "luna_#{i}" <> ".jpg"
              File.write!(Path.join(base_dir, filename), Picam.next_frame)
              filename
            end)


    task = Task.async(fn ->
      timestamp = :os.system_time
      [video_command | video_args] = "ffmpeg -f image2 -i " <> base_dir <> "luna_%d.jpg " <> base_dir <> "video.avi"
                                     |> String.split(" ")

                                     video_command |> System.cmd(video_args)

                                     gifname = "luna_#{timestamp}.gif"
                                     [gif_command | gif_args] = "ffmpeg -i " <> base_dir <> "video.avi -pix_fmt rgb24 " <> base_dir <> gifname
                                                                |> String.split(" ")
                                                                gif_command |> System.cmd(gif_args)

                                                                File.rm(Path.join(base_dir, "video.avi"))
      files |> Enum.each(fn file -> File.rm(Path.join(System.tmp_dir!, file)) end)

      @uploader.store(Path.join(System.tmp_dir!, gifname))
      @uploader.url(gifname)

      gifname
    end)
    Task.await(task)
  end

end
