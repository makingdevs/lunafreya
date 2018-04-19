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

    {:ok, pid} = Supervisor.init(children, strategy: :rest_for_one)
    UART.open(:uart_thing, "/dev/cu.usbmodem1431", speed: 9600, active: false)
    UART.configure(:uart_thing, framing: {UART.Framing.Line, separator: "\r\n"})
    {:ok, pid}
  end

end

