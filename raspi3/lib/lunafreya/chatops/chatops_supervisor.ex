defmodule Raspi3.Luna.ChatopsSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {Raspi3.Telegram.Bot, name: Raspi3.Telegram.Bot}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
