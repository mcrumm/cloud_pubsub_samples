defmodule Mix.Tasks.Subscriber.ListInTopic do
  use CloudPubsubSamples.Command
  @shortdoc "Lists subscriptions for the given topic"

  alias CloudPubsubSamples.{Project, Subscriber}

  @impl true
  def run(project, [topic | _args]) do
    case Subscriber.list_in_topic(project, topic) do
      {:ok, subscriptions} ->
        shell = Mix.shell()
        path = Project.topic_path(project, topic)
        shell.info("Listing subscriptions for #{path}:")

        Enum.each(subscriptions, &shell.info/1)
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Failed to fetch subscriptions, reason: #{inspect(reason, pretty: true)}
        """)
    end
  end
end
