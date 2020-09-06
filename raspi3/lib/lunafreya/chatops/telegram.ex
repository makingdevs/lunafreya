defmodule Raspi3.Telegram.Bot do
  alias Raspi3.Telegram.ActionServer

  use Telegram.Bot,
    token: Application.fetch_env!(:telegram, :token),
    username: Application.fetch_env!(:telegram, :username)

  command "start_watch", _args do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "starting #{inspect(update)}"
    )
  end

  command "stop_watch", _args do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "stops #{inspect(update)}"
    )
  end

  command unknown do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "Unknow command `#{unknown}`"
    )
  end

  message do
    ActionServer.echo(update)
  end

  any do
    # handler code
  end
end
