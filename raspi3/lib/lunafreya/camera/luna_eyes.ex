defmodule Raspi3.Luna.Eyes do
  @distance_for_diff 200
  @uploader Application.get_env(:pi3, :uploader)
  @base_dir System.tmp_dir!()
  @frames 60

  def see_the_same_object(distance, median) do
    case distance <= median + @distance_for_diff && distance >= median - @distance_for_diff do
      true -> :the_same
      false -> :not_the_same
    end
  end

  def have_to_see(how_is_luna) do
    case how_is_luna do
      :in_recovering -> :not_watching
      :ready_for_act -> :watching
    end
  end

  def preserve_the_moment({distance, median}, eyes_watching) do
    with :watching <- have_to_see(eyes_watching),
         :not_the_same <- see_the_same_object(distance, median) do
      :record_image
    else
      _ -> :dont_record
    end
  end

  def see do
    Picam.set_size(640, 480)

    @base_dir
    |> create_path_with_timestamp(:os.system_time())
    |> generate_filenames_tuples()
    |> capture_the_frames_with_names()
  end

  def create_path_with_timestamp(base_dir, dir_name) do
    (base_dir <> "/" <> "#{dir_name}") |> File.mkdir!()
    {base_dir, "#{dir_name}"}
  end

  def capture_frame_with_name({base, dir_name, filename}) do
    base
    |> Path.join(dir_name)
    |> Path.join(filename)
    |> File.write!(Picam.next_frame())

    {base, dir_name, filename}
  end

  def capture_the_frames_with_names(filenames) do
    filenames
    |> Enum.map(&capture_frame_with_name(&1))
  end

  def generate_filenames_tuples({base, dir_name}) do
    for n <- 1..@frames, do: {base, dir_name, "luna_#{n}" <> ".jpg"}
  end

  def upload_file(gifname) do
    case @uploader.store(Path.join(System.tmp_dir!(), gifname)) do
      {:ok, filename} ->
        url = @uploader.url(filename)
        send(Raspi3.Slack, {:message, "#{url}", "#iot"})

      message ->
        msg = "Can't upload image #{inspect(message)}"
        send(Raspi3.Slack, {:message, msg, "#iot"})
    end
  end
end
