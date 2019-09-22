defmodule CloudPubsubSamples.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts the Broadway pipeline
      {CloudPubsubSamples.Pipeline, pipeline_opts()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CloudPubsubSamples.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pipeline_opts do
    case subscription_path() do
      nil ->
        [enabled: false]

      path ->
        [enabled: true, subscription: path]
    end
  end

  # Subscription path is set automatically for publisher & subscriber Mix tasks.
  defp subscription_path do
    path = Application.get_env(:cloud_pubsub_samples, :subscription_path)

    unless path do
      Logger.error("""
      pipeline requires subscription_path, but it's not set

      The subscription path is set automatically when you run any of
      the `publisher.*` or `subscriber.*` Mix tasks.

      If you are running the application directly, you need to set
      :subscription_path manually. For instance, in the config:

      config :cloud_pubsub_samples,
        subscription_path: "projects/foo/subscriptions/bar"

      """)
    end

    path
  end
end
