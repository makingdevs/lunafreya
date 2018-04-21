defmodule Raspi3.Luna do

  alias Raspi3.Raw

  def think(%Raw{time: time} = data) do
    case {rem(time.minute, 1), time.second} do
      {0, 0} ->
        url = see_what_happens()
        send Raspi3.Slack, {:message, Raw.summary(data), "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      _ ->
        :ok
    end
  end

  def see_what_happens() do
    Picam.set_size(1280, 0)
    Picam.set_img_effect(:colorbalance)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    Raspi3.S3.store(Path.join(System.tmp_dir!, filename))
    Raspi3.S3.url(filename)
  end

end
