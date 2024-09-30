defmodule Transport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TransportWeb.Telemetry,
      Transport.Repo,
      {DNSCluster, query: Application.get_env(:transport, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Transport.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Transport.Finch},
      # Start a worker by calling: Transport.Worker.start_link(arg)
      # {Transport.Worker, arg},
      # Start to serve requests, typically the last entry
      TransportWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Transport.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TransportWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
