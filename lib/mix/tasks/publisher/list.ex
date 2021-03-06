defmodule Mix.Tasks.Publisher.List do
  use CloudPubsubSamples.Command
  @shortdoc "Lists Cloud Pub/Sub topics for the current project"

  @moduledoc """
  Lists the Google Cloud Pub/Sub topics on the current project.

  ## Usage

        mix publisher.list
  """
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, _args) do
    with {:ok, topics} <- Publisher.list_topics(project) do
      shell = Mix.shell()
      shell.info("Listing topics for projects/#{project}:")
      Enum.each(topics, fn topic -> shell.info(topic.name) end)
      :ok
    end
  end
end
