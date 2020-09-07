defmodule Raspi3.Luna.BrainServer do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, {:ready_for_act}}
  end

  def current_status() do
    GenServer.call(__MODULE__, {:current_status})
  end

  def handle_call({:current_status}, _from, state) do
    {:reply, state, state}
  end
end
