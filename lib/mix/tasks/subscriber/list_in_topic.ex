defmodule Mix.Tasks.Subscriber.ListInTopic do
  use CloudPubsubSamples.Command
  @shortdoc "Lists subscriptions for the given topic"

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
