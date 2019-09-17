defmodule CloudPubsubSamples.Subscriber do
  @moduledoc """
  Documentation for CloudPubsubSamples.Subscriber.
  """
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        default: [
          module: {
            BroadwayCloudPubSub.Producer,
            subscription: subscription_path()
          }
        ]
      ],
      processors: [
        default: []
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl Broadway
  def handle_message(_processor_name, message, _context) do
    process_message(message)
  end

  defp process_message(%Message{data: data, metadata: metadata} = message) do
    IO.puts("""
    Received message from Cloud Pub/Sub:
      Message ID: #{metadata.messageId}
      Publish Time: #{metadata.publishTime}
      Attributes:
        #{inspect(metadata.attributes)}

      The message data:
        #{inspect(data)}
    """)

    message
  end

  @impl Broadway
  def handle_batch(_, messages, _, _) do
    messages
  end

  defp subscription_path do
    # Subscription path is set automatically when running
    # `mix subscriber` from the umbrella root.
    Application.get_env(:cloud_pubsub_samples, :subscription_path)
  end
end
