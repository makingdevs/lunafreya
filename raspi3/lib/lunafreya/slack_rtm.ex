defmodule Raspi3.SlackRtm do
  use Slack
  require Logger

  def handle_connect(slack, state) do
    Logger.info "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, _slack, state) do
    # send_message("I got a message!", message.channel, slack)
    Logger.info "I got a message in #{inspect message}"
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
