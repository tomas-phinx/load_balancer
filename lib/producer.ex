defmodule LoadBalancer.Producer do
  use GenStage
  require Logger

  alias LoadBalancer.Events.UploadImageEvnt

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def upload_image(
        %Plug.Conn{params: %{"device_id" => device_id, "image" => image}},
        timeout \\ 5000
      ) do
    GenStage.call(
      __MODULE__,
      %UploadImageEvnt{sender: self(), image: image, device_id: device_id},
      timeout
    )
  end

  def init(:ok) do
    {:producer, :ok, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call(%UploadImageEvnt{} = event, _from, state) do
    {:reply, :ok, [event], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
