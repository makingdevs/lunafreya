defmodule Raspi3 do
  use Application

  def start(_type, _args) do
    children = [
      Supervisor.child_spec({Raspi3.Supervisor, []}, id: Raspi3.Supervisor),
      Raspi3.Luna
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Raspi3)
  end
end
