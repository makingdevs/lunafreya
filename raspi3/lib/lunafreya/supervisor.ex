defmodule Raspi3.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      Raspi3.HardwareSupervisor,
      Raspi3.Sensors.Job,
      Raspi3.SensorData,
      Raspi3.Telegram.Bot,
      Raspi3.Telegram.ActionServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
