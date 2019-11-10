defmodule CloudPubsubSamples.Pipeline do
  @moduledoc """
  A Broadway pipeline for consuming Cloud Pub/Sub messages.
  """
  use Broadway

  alias Broadway.Message

  @doc """
  Starts listening for messages on a Google Cloud Pub/Sub subscription.

  ## Options

  * `subscription` - The absolute path to the Cloud Pub/Sub subscription. Example: "projects/foo/subscriptions/bar"
  * `enabled` - Optional. When false, disables the pipeline. Used mostly for testing. Defaults to true.
  """
  @spec start_link(opts :: keyword) :: GenServer.on_start()
  def start_link(opts) do
    {enabled, opts} = Keyword.pop(opts, :enabled, true)

    do_start_link(enabled, opts)
  end

  defp do_start_link(false, _), do: :ignore

  defp do_start_link(true, opts) do
    subscription = Keyword.fetch!(opts, :subscription)

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayCloudPubSub.Producer,
          subscription: subscription
        }
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
end
