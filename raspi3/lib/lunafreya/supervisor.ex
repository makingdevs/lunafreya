defmodule Raspi3.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {Nerves.UART, [name: Raspi3.Arduino.Serial]},
      {Raspi3.Sensors.Data, []},
      {Raspi3.Writer, []}
    ]

    IO.inspect children

    Supervisor.init(children, strategy: :rest_for_one)
  end

end

