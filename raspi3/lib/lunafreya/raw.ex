defmodule Raspi3.Raw do
  alias __MODULE__

  @enforce_keys [:time, :sensor_data]
  defstruct time: nil, sensor_data: "", temperature: 0, light: 0, moving: 0, distance: 0

  def new(data) do
    %Raw{time: DateTime.utc_now(), sensor_data: data}
    |> parse_data
  end

  def parse_data(%Raw{} = raw) do
    sensors = String.split(raw.sensor_data, "|")
    |> Enum.filter(fn e -> e != " " end)
    |> Enum.map(&(String.trim/1))
    |> Enum.map(&(Integer.parse/1))
    [{temperature, _}, {light, _}, {moving, _}, {distance, _}] = sensors
    %Raspi3.Raw{raw | temperature: temperature, light: light, moving: moving, distance: distance}
  end

  def summary(%Raw{} = raw) do
    "Temperature: #{raw.temperature}, Light: #{raw.light}, change position?: #{raw.moving}, Distance: #{raw.distance}"
  end

end
