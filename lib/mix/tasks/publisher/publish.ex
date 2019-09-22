defmodule Mix.Tasks.Publisher.Publish do
  use CloudPubsubSamples.Command
  @shortdoc "Publishes messages to a Cloud Pub/Sub topic"

  @moduledoc """
  Publishes messages to a Google Cloud Pub/Sub topic.

  ## Usage

        mix publisher.publish topic_name
  """

  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, [topic | _args]) do
    with {:ok, response} <- Publisher.publish(project, topic) do
      %{messageIds: message_ids} = response

      shell = Mix.shell()

      Enum.each(message_ids, fn id ->
        shell.info("Published Message #{id}")
      end)

      :ok
    end
  end
end
