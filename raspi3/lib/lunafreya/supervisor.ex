defmodule Raspi3.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(_arg) do
    children = [
      {Nerves.UART, [name: :uart_thing]},
      {Raspi3.Arduino, []},
      {Raspi3.Writer, []}
    ]

    IO.inspect children

    Supervisor.init(children, strategy: :rest_for_one)
  end

end

