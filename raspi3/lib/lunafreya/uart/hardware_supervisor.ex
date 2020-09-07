defmodule Raspi3.Luna.UARTSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    uart = Application.get_env(:pi3, :uart)

    children = [
      Raspi3.Sensors.Job,
      Raspi3.Sensors.Data,
      {uart, [name: Raspi3.Arduino.Serial]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
