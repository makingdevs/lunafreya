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
    assert Eyes.have_to_see(:not_busy) == :watching
  end

  test "luna have not to use the eyes" do
    assert Eyes.have_to_see(:busy) == :not_watching
  end

  test "luna has to record the image" do
    assert Eyes.preserve_the_moment( {100,100}, :busy    ) == :dont_record
    assert Eyes.preserve_the_moment( {100,100}, :not_busy) == :dont_record
    assert Eyes.preserve_the_moment( {400,100}, :busy    ) == :record_image
    assert Eyes.preserve_the_moment( {400,100}, :not_busy) == :dont_record
  end

end
