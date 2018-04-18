defmodule Raspi3.Arduino do
  use GenServer

  alias Nerves.UART

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    # { :ok, pid } = UART.start_link(opts)
    # UART.open(pid, "/dev/cu.usbmodem1431", speed: 9600, active: false)
    # UART.configure(pid, framing: {UART.Framing.Line, separator: "\r\n"})
    # {:ok, %{}}
    {:ok, state}
  end

  def handle_call(:summary, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:put, data}, state) do
    {:noreply, [data | state]}
  end

end

