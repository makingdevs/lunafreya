defmodule Raspi3.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do

    token = Application.get_env(:slack, :api_token)

    children = [
      {Nerves.UART, [name: Raspi3.Arduino.Serial]},
      {Raspi3.Sensors.Job, []},
      {Raspi3.Writer, []},
      %{
        id: Slack.Bot,
        name: Raspi3.Slack,
        start: {
          Slack.Bot, :start_link,
          [Raspi3.SlackRtm, [], token, %{name: Raspi3.Slack}]
        }
      }
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

end

