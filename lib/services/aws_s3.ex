defmodule LoadBalancer.Services.AWSs3 do
  alias LoadBalancer.Events.UploadImageEvnt

  require Logger

  def upload_file(%UploadImageEvnt{
        sender: sender,
        image: %Plug.Upload{filename: filename, path: file_path} = upload,
        device_id: device_id
      }) do
    {:ok, _image} = File.read(file_path)

    Logger.info("Uploading image #{filename} from device #{device_id}")
    Logger.info("Upload image #{inspect(upload)}")

    :timer.sleep(1000)

    Logger.info("Finished file upload...")

    send(sender, {:ok, "path/to/image/#{device_id}/#{filename}"})
  end

  def upload_file(event), do: Logger.info("Unhandled event: #{inspect(event)}")

  def start_link(event) do
    Task.start_link(fn ->
      upload_file(event)
    end)
  end
end
