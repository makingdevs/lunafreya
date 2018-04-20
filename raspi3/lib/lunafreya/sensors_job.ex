defmodule Raspi3.Sensors.Job do
  use GenServer
  require Logger
  alias Nerves.UART

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    UART.open(Raspi3.Arduino.Serial, "/dev/cu.usbmodem1431", speed: 9600, active: false)
    UART.configure(Raspi3.Arduino.Serial, framing: {UART.Framing.Line, separator: "\r\n"})
    {:ok, state, 1000}
  end

  def handle_info(:timeout, state) do
    get_data = fn -> UART.read(Raspi3.Arduino.Serial, 1000) end
    Raspi3.Writer.write_info(get_data)
    {:noreply, state, 1000}
  end

end

