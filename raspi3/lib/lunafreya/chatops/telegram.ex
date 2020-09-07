defmodule Raspi3.Telegram.Bot do
  alias Raspi3.Telegram.Actions

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

  command "see", _args do
    Actions.send_photo(update)
  end

  command unknown do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "Unknow command `#{unknown}`"
    )
  end

  message do
    Actions.echo(update)
  end

  any do
    # handler code
  end
end
