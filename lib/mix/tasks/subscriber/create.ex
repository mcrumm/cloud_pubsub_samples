defmodule Mix.Tasks.Subscriber.Create do
  use CloudPubsubSamples.Command
  @shortdoc "Creates a subscription for a Pub/Sub topic"

  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, [topic, subscription | _args]) do
    with {:ok, subscription} <- Subscriber.create_subscription(project, topic, subscription) do
      Mix.shell().info("Created subscription #{subscription.name}")
      :ok
    end
  end
end
