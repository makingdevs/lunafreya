defmodule Raspi3.Telegram.Actions do
  @token Application.fetch_env!(:telegram, :token)

  def send_message(chat_id, message) do
    Telegram.Api.request(@token, "sendMessage",
      chat_id: chat_id,
      text: message
    )
  end

  def send_photo(chat_id, photo_url) do
    Telegram.Api.request(@token, "sendPhoto",
      chat_id: chat_id,
      photo: {:file, photo_url}
    )
  end
end
