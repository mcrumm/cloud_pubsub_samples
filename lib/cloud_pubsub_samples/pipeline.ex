defmodule CloudPubsubSamples.Pipeline do
  @moduledoc """
  A Broadway pipeline for consuming Cloud Pub/Sub messages.
  """
  use Broadway

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
          subscription: subscription, max_number_of_messages: 500
        },
        stages: 20
      ],
      processors: [
        default: [
          min_demand: 100,
          max_demand: 500
        ]
      ],
      batchers: [
        default: [
          batch_size: 500,
          batch_timeout: 2_000
        ]
      ]
    )
  end

  @impl Broadway
  def handle_message(_processor_name, message, _context) do
    message
  end

  @impl Broadway
  def handle_batch(_, messages, _, _) do
    ids = Enum.map(messages, & &1.metadata.messageId)

    IO.inspect(ids, label: "Acknowledging batch of #{length(ids)}")

    messages
  end
end
