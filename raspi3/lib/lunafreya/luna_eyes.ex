defmodule Raspi3.Luna.Eyes do

  @distance_for_diff 50

  def see_the_same_object(distance, median) do
    case distance <= (median + @distance_for_diff) && distance >= (median - @distance_for_diff) do
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
         :not_the_same <- see_the_same_object(distance, median)
    do :record_image
    else
      _ -> :dont_record
    end
  end

end

