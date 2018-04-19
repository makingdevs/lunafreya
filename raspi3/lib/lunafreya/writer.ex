defmodule Raspi3.Writer do
  use GenServer
  alias Nerves.UART

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def write_info(message) do
    GenServer.cast(__MODULE__, {:write, message})
  end

  def handle_cast({:write, message}, state) do
    # IO.puts "I'm writing a new incoming message #{inspect state}"
    IO.inspect UART.read(:uart_thing, 6000)
    {:noreply, [message | state]}
  end
end
