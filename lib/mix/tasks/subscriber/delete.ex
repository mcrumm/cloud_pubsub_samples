defmodule Mix.Tasks.Subscriber.Delete do
  use CloudPubsubSamples.Command
  @shortdoc "Deletes a subscription for a Pub/Sub topic"

  alias CloudPubsubSamples.{Project, Subscriber}

  @impl true
  def run(project, [subscription | _args]) do
    case Subscriber.delete_subscription(project, subscription) do
      :ok ->
        subscription = Project.subscription_path(project, subscription)
        Mix.shell().info("Deleted subscription #{subscription}")
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Failed to delete subscription, reason: #{inspect(reason)}
        """)
    end
  end
end
