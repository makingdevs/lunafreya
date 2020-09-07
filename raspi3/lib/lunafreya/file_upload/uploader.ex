defmodule Raspi3.Luna.Uploader do
  @uploader Application.get_env(:pi3, :uploader)

  def upload_file(full_file_path) do
    case @uploader.store(full_file_path) do
      {:ok, filename} ->
        {:ok, @uploader.url(filename)}

      message ->
        {:error, "Can't upload image #{inspect(message)}"}
    end
  end
end
