defmodule Raspi3.Luna.EyesSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    camera = Application.get_env(:picam, :camera, Picam.Camera)

    children = [
      Raspi3.Luna.EyesServer,
      camera
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
