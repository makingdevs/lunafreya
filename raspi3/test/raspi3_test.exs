defmodule Raspi3Test do
  use ExUnit.Case
  doctest Raspi3

  test "greets the world" do
    assert Raspi3.hello() == :world
  end
end
