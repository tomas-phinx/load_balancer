defmodule LoadBalancer.Consumer do
    use ConsumerSupervisor

    def start_link(arg) do
      ConsumerSupervisor.start_link(__MODULE__, arg)
    end
  
    def init(_arg) do
      children = [%{id: LoadBalancer.Services.AWSs3, start: {LoadBalancer.Services.AWSs3, :start_link, []}, restart: :transient}]
      opts = [strategy: :one_for_one, subscribe_to: [{LoadBalancer.Producer, max_demand: 25}]]

      ConsumerSupervisor.init(children, opts)
    end
end
