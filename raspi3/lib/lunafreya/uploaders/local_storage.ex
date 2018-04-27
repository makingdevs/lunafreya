defmodule Raspi3.LocalStorage do
  use Arc.Definition

  @versions [:original, :thumb]

  def __storage, do: Arc.Storage.Local

end
