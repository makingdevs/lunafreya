defmodule Raspi3.Luna do

  alias Raspi3.Raw

  def think(%Raw{time: time, sensor_data: data}) do
    url = see_what_happens()
    case {time.minute, time.second} do
      {0, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      {15, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      {30, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      {45, 0 } ->
        send Raspi3.Slack, {:message, data, "#iot"}
        send Raspi3.Slack, {:message, url, "#iot"}
      _ ->
        :ok
    end
  end

  def see_what_happens() do
    Picam.set_size(1280, 0)
    filename = "#{:os.system_time}" <> ".jpg"
    File.write!(Path.join(System.tmp_dir!, filename), Picam.next_frame)
    Raspi3.S3.store(Path.join(System.tmp_dir!, filename))
    Raspi3.S3.url(filename)
  end

end
