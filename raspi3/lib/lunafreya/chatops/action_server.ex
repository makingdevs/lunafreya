defmodule Raspi3.Telegram.Actions do
  @token Application.fetch_env!(:telegram, :token)

  def echo(event_info) do
    Telegram.Api.request(@token, "sendMessage",
      chat_id: event_info["chat"]["id"],
      text: event_info["text"]
    )
  end

  def send_photo(event_info) do
    photo_url = "/Users/makingdevs/Downloads/giphy.gif"
    # photo_url = "https://media.giphy.com/media/lQDLwWUMPaAHvh8pAG/giphy.gif"

    Telegram.Api.request(@token, "sendPhoto",
      chat_id: event_info["chat"]["id"],
      photo: {:file, photo_url}
    )
  end
end
