defmodule Raspi3.Luna.BrainTasks do
  alias Raspi3.Luna.Eyes
  alias Raspi3.Luna.Uploader
  alias Raspi3.Telegram.Actions

  @sizes %{
    "small" => [width: 640, height: 480],
    "medium" => [width: 1280, height: 720],
    "big" => [width: 1920, height: 1080]
  }

  @any_num ~r/^\d{1,2}$/

  def see_the_ambience(chat_id, args \\ []) do
    frames = read_frames(args)

    size = read_image_size(args)

    Eyes.see(frames, size)
    |> upload_files()
    |> send_photo_messages(chat_id)
  end

  defp upload_files(%{base_dir: base_dir, sub_dir: sub_dir, filenames: filenames}) do
    filenames
    |> Enum.map(fn f ->
      base_dir |> Path.join(sub_dir) |> Path.join(f) |> Uploader.upload_file()
    end)
  end

  def send_photo_messages(files, chat_id) do
    for({:ok, f} <- files, do: f)
    |> Enum.map(&Actions.send_photo(chat_id, &1))
  end

  defp read_frames(args) do
    with a <- Enum.find(args, &String.match?(&1, @any_num)),
         true <- not is_nil(a),
         n <- String.to_integer(a) do
      n
    else
      _ ->
        1
    end
  end

  def read_image_size(args) do
    for({s, v} <- @sizes, a <- args, a == s, do: v)
    |> List.first()
    |> select_size()
  end

  defp select_size(nil), do: @sizes["small"]
  defp select_size(s), do: s
end
