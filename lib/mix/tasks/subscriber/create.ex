defmodule Mix.Tasks.Subscriber.Create do
  use CloudPubsubSamples.Command
  @shortdoc "Creates a subscription for a Cloud Pub/Sub topic"

  @moduledoc """
  Creates a Google Cloud Pub/Sub subscription for the given topic.

  The topic must exist on the current project.

  ## Usage

        mix subscriber.create topic_name subscription_name
  """
  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, [topic, subscription | _args]) do
    with {:ok, subscription} <- Subscriber.create_subscription(project, topic, subscription) do
      Mix.shell().info("Created subscription #{subscription.name}")
      :ok
    end
  end
end
