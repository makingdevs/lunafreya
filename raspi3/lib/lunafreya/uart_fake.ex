defmodule Raspi3.UART.Fake do

  use GenServer

  require Logger

  defmodule Framing do
    defmodule Line do
    end
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    state = " | 1 | 1 | 1 | 1 | "
    {:ok, state}
  end

  def write_sensors_values(data) do
    GenServer.cast(__MODULE__, {:write, data})
  end

  def read_sensors_values() do
    GenServer.call(__MODULE__, {:read})
  end

  def open(module_name, port, opts) do
    Logger.info "Opening: #{inspect(module_name)} - Port: #{inspect(port)} - Opts: #{inspect(opts)}"
    :ok
  end

  def configure(module_name, opts) do
    Logger.info "Configuring: #{inspect(module_name)} - Opts: #{inspect(opts)}"
    :ok
  end

  def read(_module_name, _opts) do
    # Logger.info "Reading value from Serial port"
    data = read_sensors_values()
    {:ok,  data}
  end

  def handle_call({:read}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:write, data}, _state) do
    {:noreply, data}
  end

end
