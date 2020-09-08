defmodule Raspi3.Luna.Eyes do
  alias Raspi3.Raw

  @distance_for_diff 200

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

  def check_what_is_seeing(%Raw{distance: distance}, data_for_last_seconds, {how_is_luna}) do
    [temperature: _, distance: [mean: mean_d, median: median_d], light: _, moving: _] =
      Raw.statistics(data_for_last_seconds)

    # TODO: This logic needs a test, and not is a gen_server
    case how_is_luna do
      :ready_for_act ->
        case preserve_the_moment({distance, median_d}, how_is_luna) do
          :record_image ->
            :in_recovering

          :dont_record ->
            :ready_for_act
        end

      :in_recovering ->
        case mean_d <= median_d + 2 && mean_d >= median_d - 2 do
          true -> :ready_for_act
          false -> :in_recovering
        end
    end
  end

  def see(frames \\ 1, [width: width, height: height] \\ [width: 640, height: 480]) do
    Picam.set_size(width, height)
    Picam.set_rotation(180)

    System.tmp_dir!()
    |> map_info_for_photos()
    |> generate_filenames(frames)
    |> capture_the_frames_with_names()
  end

  defp map_info_for_photos(base_dir) do
    %{base_dir: base_dir, sub_dir: "#{:os.system_time()}"}
  end

  defp capture_frame_with_name({base, dir_name, filename}) do
    base
    |> Path.join(dir_name)
    |> Path.join(filename)
    |> File.write!(Picam.next_frame())

    {base, dir_name, filename}
  end

  defp capture_the_frames_with_names(map_info) do
    create_temp_dir(map_info)

    map_info
    |> tuples_with_info()
    |> Enum.map(&capture_frame_with_name(&1))

    map_info
  end

  defp tuples_with_info(%{base_dir: base_dir, sub_dir: sub_dir, filenames: filenames}) do
    for f <- filenames, do: {base_dir, sub_dir, f}
  end

  defp create_temp_dir(%{base_dir: base_dir, sub_dir: sub_dir}) do
    base_dir
    |> Path.join(sub_dir)
    |> File.mkdir()
  end

  defp generate_filenames(map, frames) do
    map
    |> Map.put(:filenames, for(n <- 1..frames, do: "luna_#{n}" <> ".jpg"))
  end
end
