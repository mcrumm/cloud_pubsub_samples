defmodule Mix.Tasks.Publisher.Delete do
  use CloudPubsubSamples.Command
  @shortdoc "Deletes a Cloud Pub/Sub topic"

  @moduledoc """
  Deletes a Google Cloud Pub/Sub topic on the current project.
  """
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, [topic_name | _args]) do
    case Publisher.delete_topic(project, topic_name) do
      {:ok, _empty} ->
        Mix.shell().info("Deleted topic #{topic_name}")
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Error deleting topic, reason: #{inspect(reason)}
        """)
    end
  end
end
