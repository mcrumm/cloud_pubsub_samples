defmodule Mix.Tasks.Publisher.Create do
  use CloudPubsubSamples.Command
  @shortdoc "Creates a Cloud Pub/Sub topic"

  @moduledoc """
  Creates a Google Cloud Pub/Sub topic on the current project.
  """
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, [topic_name | _args]) do
    case Publisher.create_topic(project, topic_name) do
      {:ok, topic} ->
        Mix.shell().info("Created topic #{topic.name}")
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Error creating topic: #{inspect(reason)}
        """)
    end
  end
end
