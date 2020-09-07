defmodule Raspi3.Luna.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      Raspi3.Luna.EyesSupervisor,
      Raspi3.Luna.SensorsSupervisor,
      Raspi3.Luna.ChatopsSupervisor,
      {Task.Supervisor, name: Raspi3.Luna.TaskSupervisor},
      Raspi3.Luna.BrainSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
