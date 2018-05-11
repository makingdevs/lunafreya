defmodule Raspi3.Luna.EyesTest do
  use ExUnit.Case

  alias Raspi3.Luna.Eyes

  test "object is in range of vision" do
    assert Eyes.object_is_in_range(100, 100) == :in_range
  end

  test "object is not in range of vision" do
    assert Eyes.object_is_in_range(400, 100) == :out_of_range
  end

end

