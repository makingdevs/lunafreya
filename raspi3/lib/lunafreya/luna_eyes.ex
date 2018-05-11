defmodule Raspi3.Luna.Eyes do

  @distance_for_diff 50

  def object_is_in_range(distance, median) do
    case distance <= (median + @distance_for_diff) && distance >= (median - @distance_for_diff) do
      true ->
        :in_range
      false ->
        :out_of_range
    end
  end


end

