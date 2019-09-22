defmodule Mix.Tasks.Subscriber.ListInTopic do
  use CloudPubsubSamples.Command
  @shortdoc "Lists Cloud Pub/Sub subscriptions for a topic"

  @moduledoc """
  Lists the Google Cloud Pub/Sub subscriptions for the current project.

  The topic must exist in the current project.

  ## Usage

        mix subscriber.list_in_topic topic_name
  """
  alias CloudPubsubSamples.{Project, Subscriber}

  @impl true
  def run(project, [topic | _args]) do
    with {:ok, subscriptions} <- Subscriber.list_in_topic(project, topic) do
      shell = Mix.shell()
      path = Project.topic_path(project, topic)
      shell.info("Listing subscriptions for #{path}:")

      Enum.each(subscriptions, &shell.info/1)
      :ok
    end
  end
end
