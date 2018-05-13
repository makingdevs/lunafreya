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
    case sensors do
      [{temperature, _}, {light, _}, {moving, _}, {distance, _}] ->
        %Raspi3.Raw{raw | temperature: temperature, light: light, moving: moving, distance: distance}
      _ ->
        raw
    end
  end

  def summary(%Raw{} = raw) do
    "Temperature: #{raw.temperature}, Light: #{raw.light}, change position?: #{raw.moving}, Distance: #{raw.distance}"
  end

  def statistics(raw_list) do
    n = case { x = Enum.count(raw_list) } do
      { 0 } -> 1
      _ -> x
    end

    temperatures = (for r <- raw_list, do: r.temperature) |> Enum.sort
    distances = (for r <- raw_list, do: r.distance) |> Enum.sort
    lights = (for r <- raw_list, do: r.light) |> Enum.sort
    movings = (for r <- raw_list, do: r.moving) |> Enum.sort

    mean_temperature = (temperatures |> Enum.sum) / n
    mean_distance = (distances |> Enum.sum) / n
    mean_light = (lights |> Enum.sum) / n
    mean_moving = (movings |> Enum.sum) / n

    median_temperature = temperatures |> median
    median_distance = distances |> median
    median_light = lights |> median
    median_moving = movings |> median

    {
      :temperature, { :average, mean_temperature}, { :median, median_temperature},
      :distance, { :average, mean_distance}, { :median, median_distance},
      :light, { :average, mean_light}, { :median, median_light},
      :moving, { :average, mean_moving}, { :median, median_moving}
    }

  end

  defp median([]), do: 0
  defp median(list) when is_list(list) do
    mid = length(list)/2 |> Float.floor |> round
    {left, right} = list |> Enum.split(mid)
    case length(right) > length(left) do
      true ->
        [m|_] = right
        m
      false ->
        [m1|_] = right
        [m2|_] = Enum.reverse(left)
        (m1+m2) / 2
    end
  end

end
