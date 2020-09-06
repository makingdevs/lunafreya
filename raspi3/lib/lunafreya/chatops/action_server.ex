defmodule Raspi3.Telegram.ActionServer do
  use GenServer

  @token Application.fetch_env!(:telegram, :token)

  def(start_link(_)) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def echo(event_info) do
    GenServer.cast(__MODULE__, {:echo, event_info})
  end

  def last_event do
    GenServer.call(__MODULE__, :last_event)
  end

  # Callbacks

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:echo, event_info}, _state) do
    IO.inspect(event_info)

    Telegram.Api.request(@token, "sendMessage",
      chat_id: event_info["chat"]["id"],
      text: "Hello! .. silently"
    )

    {:noreply, event_info}
  end

  @impl true
  def handle_call(:last_event, _from, state) do
    {:reply, state, state}
  end
end
