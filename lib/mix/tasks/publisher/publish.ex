defmodule Mix.Tasks.Publisher.Publish do
  use CloudPubsubSamples.Command
  @shortdoc "Publishes messages to a Cloud Pub/Sub topic"

  alias CloudPubsubSamples.Publisher

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
