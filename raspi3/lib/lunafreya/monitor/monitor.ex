defmodule Raspi3.Monitor do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    schedule_work()
    IO.puts("Hello!!!")
    {:noreply, state}
  end

  defp schedule_work do
    # In 2 hours
    Process.send_after(self(), :work, 2 * 1000)
  end
end
