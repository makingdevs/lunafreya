defmodule Raspi3.Arduino do
  use GenServer

  alias Nerves.UART
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    UART.open(:uart_thing, "/dev/cu.usbmodem1431", speed: 9600, active: false)
    UART.configure(:uart_thing, framing: {UART.Framing.Line, separator: "\r\n"})

    {:ok, state, 1000}
  end

  def handle_call(:summary, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:put, data}, state) do
    {:noreply, [data | state]}
  end

  def handle_info(:timeout, state) do
    Raspi3.Writer.write_info(:os.system_time(:millisecond))
    {:noreply, state, 1000}
  end

end

