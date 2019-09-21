defmodule Mix.Tasks.Subscriber.Create do
  use CloudPubsubSamples.Command
  @shortdoc "Creates a subscription for a Pub/Sub topic"

  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, [topic, subscription | _args]) do
    case Subscriber.create_subscription(project, topic, subscription) do
      {:ok, subscription} ->
        Mix.shell().info("Created subscription #{subscription.name}")
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Error creating subscription, reason: #{inspect(reason)}
        """)
    end
  end
end
