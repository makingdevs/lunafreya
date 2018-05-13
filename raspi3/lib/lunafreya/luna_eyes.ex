defmodule Raspi3.Luna.Eyes do

  @distance_for_diff 50

  def see_the_same_object(distance, median) do
    case distance <= (median + @distance_for_diff) && distance >= (median - @distance_for_diff) do
      true -> :the_same
      false -> :not_the_same
    end
  end

  def have_to_see(eyes_state) do
    case eyes_state do
      :busy -> :not_watching
      :not_busy -> :watching
    end
  end

  def preserve_the_moment({distance, median}, eyes_watching) do
    case have_to_see(eyes_watching) do
      :not_watching ->
        case see_the_same_object(distance, median) do
          :not_the_same ->
            :record_image
          :the_same ->
            :dont_record
        end
      :watching ->
        :dont_record
    end
  end

end

