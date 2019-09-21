defmodule Mix.Tasks.Publisher.Delete do
  use CloudPubsubSamples.Command
  @shortdoc "Deletes a Cloud Pub/Sub topic"

  @moduledoc """
  Deletes a Google Cloud Pub/Sub topic on the current project.
  """
  import CloudPubsubSamples.Project, only: [topic_path: 2]
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, [topic_name | _args]) do
    with {:ok, _} <- Publisher.delete_topic(project, topic_name) do
      Mix.shell().info("Deleted topic #{topic_path(project, topic_name)}")
      :ok
    end
  end
end
