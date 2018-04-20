defmodule Raspi3.Raw do

  @enforce_keys [:time, :sensor_data]
  defstruct time: nil, sensor_data: ""

  def new(data) do
    %Raspi3.Raw{time: DateTime.utc_now(), sensor_data: data}
  end

end
