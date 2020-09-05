defmodule Raspi3.Luna.EyesServer do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  def open_the_eyes() do
    GenServer.call(__MODULE__, {:open_the_eyes})
  end

  def handle_call({:open_the_eyes}, _from, state) do
    Logger.debug("Opening the eyes!")

    result =
      Task.start(fn ->
        Logger.debug("Starting a task")
        # see_what_happens()
        Logger.debug("Finishing the task")
      end)

    {:reply, result, state}
  end
end
