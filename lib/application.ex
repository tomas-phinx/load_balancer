defmodule LoadBalancer.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: LoadBalancer.Router, options: [port: 8080]},
      %{
        id: LoadBalancer.Producer,
        start: {LoadBalancer.Producer, :start_link, []}
      },
      %{
        id: LoadBalancer.Consumer,
        start: {LoadBalancer.Consumer, :start_link, [[]]}
      }
    ]

    opts = [strategy: :one_for_one, name: LoadBalancer.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
