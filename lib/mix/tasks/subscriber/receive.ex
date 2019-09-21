defmodule Mix.Tasks.Subscriber.Receive do
  use CloudPubsubSamples.Command
  @shortdoc "Listens for messages on a Pub/Sub subscription"

  @moduledoc """
  Starts listening for messages on the given subscription.

  The `--no-halt` flag is automatically added.

  Usage: `mix subscriber.receive <subscription_name>`
  """
  import CloudPubsubSamples.Project, only: [subscription_path: 2]

  @impl true
  def run(project, [subscription | args]) do
    path = subscription_path(project, subscription)

    Application.put_env(
      :cloud_pubsub_samples,
      :subscription_path,
      path,
      persistent: true
    )

    Mix.shell().info("""
    Listening for messages on #{path} - Press Ctrl+C to exit
    """)

    Mix.Tasks.Run.run(run_args() ++ args)

    :ok
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end
end
