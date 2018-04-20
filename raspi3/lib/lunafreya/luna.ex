defmodule Raspi3.Luna do

  alias Raspi3.Raw

  def think(%Raw{time: time, sensor_data: data}) do
    case {time.minute, time.second} do
      {0, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
      {15, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
      {30, 0} ->
        send Raspi3.Slack, {:message, data, "#iot"}
      {45, 0 } ->
        send Raspi3.Slack, {:message, data, "#iot"}
      _ ->
        :ok
    end
  end

end
