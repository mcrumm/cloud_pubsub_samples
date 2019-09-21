defmodule Mix.Tasks.Publisher.Create do
  use CloudPubsubSamples.Command
  @shortdoc "Creates a Cloud Pub/Sub topic"

  @moduledoc """
  Creates a Google Cloud Pub/Sub topic on the current project.
  """
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, [topic_name | _args]) do
    with {:ok, topic} <- Publisher.create_topic(project, topic_name) do
      Mix.shell().info("Created topic #{topic.name}")
      :ok
    end
  end
end
