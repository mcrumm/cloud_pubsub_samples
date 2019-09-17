defmodule Mix.Tasks.Subscriber do
  use Mix.Task
  alias CloudPubsubSamples.Project

  @shortdoc "Commands for Cloud Pub/Sub Subscriptions"

  @moduledoc """
  Commands for interacting with Cloud Pub/Sub subscriptions.

  **Commands**

    * `receive` - Starts listening for messages on the given subscription.
                  The `--no-halt` flag is automatically added.
                  Usage: `mix subscriber receive <subscription_name>`
  """

  @impl true
  @doc false
  def run(["receive", subscription | args]) do
    with {:ok, path} <- Project.init_for_receive(subscription) do
      Application.put_env(:cloud_pubsub_samples, :subscription_path, path, persistent: true)
      Mix.shell().info("Listening for messages on #{path} - Press Ctrl+C to exit")

      Mix.Tasks.Run.run(run_args() ++ args)
      :ok
    else
      {:error, reason} ->
        raise reason
    end
  end

  def run(_) do
    Mix.shell().info("usage: mix subscriber [-h] {create, receive} ...")
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end
end
