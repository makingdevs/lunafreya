defmodule Raspi3.Luna.EyesTest do
  use ExUnit.Case

  alias Raspi3.Luna.Eyes

  test "is seeing the same object" do
    assert Eyes.see_the_same_object(100, 100) == :the_same
  end

  test "is not seeing the same object" do
    assert Eyes.see_the_same_object(400, 100) == :not_the_same
    assert Eyes.see_the_same_object(400, 10) == :not_the_same
  end

  test "luna have to use the eyes" do
    assert Eyes.have_to_see(:ready_for_act) == :watching
  end

  test "luna have not to use the eyes" do
    assert Eyes.have_to_see(:in_recovering) == :not_watching
  end

  test "luna has to record the image" do
    assert Eyes.preserve_the_moment( {100,100}, :in_recovering) == :dont_record
    assert Eyes.preserve_the_moment( {100,100}, :ready_for_act) == :dont_record
    assert Eyes.preserve_the_moment( {400,100}, :in_recovering) == :dont_record
    assert Eyes.preserve_the_moment( {400,100}, :ready_for_act) == :record_image
    assert Eyes.preserve_the_moment( {400,350}, :ready_for_act) == :dont_record
  end

end
