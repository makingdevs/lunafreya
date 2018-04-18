defmodule Raspi3.Arduino do
  use GenServer

  alias Nerves.UART

  def start_link(opts \\ []) do
    { :ok, pid } = UART.start_link(__MODULE__, :ok, opts)
    UART.open(pid, "ttyACM0", speed: 9600, active: true)
    UART.configure(pid, framing: {UART.Framing.Line, separator: "\r\n"})
    { :ok, pid }
  end

  def init(:ok) do
    {:ok, %{}}
  end
end

