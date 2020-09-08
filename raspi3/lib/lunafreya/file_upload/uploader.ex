defmodule Raspi3.Luna.Uploader do
  @uploader Application.get_env(:pi3, :uploader)

  def upload_file(full_file_path) do
    case @uploader.store(full_file_path) do
      {:ok, filename} ->
        {:ok, create_url(filename, @uploader)}

      message ->
        {:error, "Can't upload image #{inspect(message)}"}
    end
  end

  defp create_url(filename, Raspi3.LocalStorage) do
    "." <> @uploader.url(filename)
  end

  defp create_url(filename, _) do
    @uploader.url(filename)
  end
end
