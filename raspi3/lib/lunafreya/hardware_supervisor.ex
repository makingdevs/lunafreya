defmodule Raspi3.HardwareSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    camera = Application.get_env(:picam, :camera, Picam.Camera)
    uart = Application.get_env(:pi3, :uart)

    children = [
      {uart, [name: Raspi3.Arduino.Serial]},
      camera
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
