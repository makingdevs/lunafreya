defmodule Raspi3.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    token = Application.get_env(:slack, :api_token)

    children = [
      Raspi3.HardwareSupervisor,
      {Raspi3.Sensors.Job, []},
      {Raspi3.SensorData, []}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
