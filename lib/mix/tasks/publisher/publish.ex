defmodule Mix.Tasks.Publisher.Publish do
  use CloudPubsubSamples.Command
  @shortdoc "Publishes messages to a Cloud Pub/Sub topic"

  alias CloudPubsubSamples.Publisher

  def run(project, [topic | _args]) do
    case Publisher.publish(project, topic) do
      {:ok, response} ->
        %{messageIds: message_ids} = response

        shell = Mix.shell()

        Enum.each(message_ids, fn id ->
          shell.info("Published Message #{id}")
        end)

        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Error publishing messages, reason: #{inspect(reason)}
        """)
    end
  end
end
