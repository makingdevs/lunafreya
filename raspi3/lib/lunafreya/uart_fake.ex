defmodule Raspi3.UART.Fake do

  use GenServer

  require Logger

  defmodule Framing do
    defmodule Line do
    end
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    {:ok, state}
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
    {:ok,  " | 1 | 1 | 1 | 1 | "}
  end

end
