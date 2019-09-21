defmodule Mix.Tasks.Subscriber.Delete do
  use CloudPubsubSamples.Command
  @shortdoc "Deletes a subscription for a Pub/Sub topic"

  import CloudPubsubSamples.Project, only: [subscription_path: 2]
  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, [subscription | _args]) do
    with {:ok, _} <- Subscriber.delete_subscription(project, subscription) do
      subscription = subscription_path(project, subscription)
      Mix.shell().info("Deleted subscription #{subscription}")
      :ok
    end
  end
end
