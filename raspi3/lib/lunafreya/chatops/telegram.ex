defmodule Raspi3.Telegram.Bot do
  use Telegram.Bot,
    token: "***REMOVED***",
    username: "luna_freya_bot"

  command ["ciao", "hello"], args do
    # handle the commands: "/ciao" and "/hello"

    # reply with a text message
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "ciao! #{inspect(args)}"
    )
  end

  command "start_watch", _args do
    {:ok, _} = GenServer.start_link(Raspi3.Monitor, [], name: Raspi3.Monitor)

    IO.puts("Start watch")

    send_message = fn ->
      request("sendMessage",
        chat_id: update["chat"]["id"],
        text: "starting #{inspect(update)}"
      )
    end

    send_message.()
  end

  command "stop_watch", _args do
    {:ok, _} = GenServer.stop(Raspi3.Monitor)

    IO.puts("Stop watch")

    send_message = fn ->
      request("sendMessage",
        chat_id: update["chat"]["id"],
        text: "stops #{inspect(update)}"
      )
    end

    send_message.()
  end

  command unknown do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "Unknow command `#{unknown}`"
    )
  end

  message do
    request("sendMessage",
      chat_id: update["chat"]["id"],
      text: "Hey! You sent me a message: #{inspect(update)}"
    )
  end

  edited_message do
    # handler code
  end

  channel_post do
    # handler code
  end

  edited_channel_post do
    # handler code
  end

  inline_query _query do
    # handler code
  end

  chosen_inline_result _query do
    # handler code
  end

  callback_query do
    # handler code
  end

  shipping_query do
    # handler code
  end

  pre_checkout_query do
    # handler code
  end

  any do
    # handler code
  end
end
