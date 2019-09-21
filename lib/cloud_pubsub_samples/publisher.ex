defmodule CloudPubsubSamples.Publisher do
  import CloudPubsubSamples.Connections

  import GoogleApi.PubSub.V1.Api.Projects,
    only: [
      pubsub_projects_topics_publish: 4
    ]

  alias GoogleApi.PubSub.V1.Model.{PublishRequest, PubsubMessage}

  @doc """
  Publishes messages to the given project/topic
  """
  def publish(project, topic, opts \\ []) do
    num_messages = Keyword.get(opts, :num_messages, 10)
    messages = build_messages(num_messages)

    with {:ok, conn} <- new_connection(token_generator()) do
      pubsub_projects_topics_publish(
        conn,
        project,
        topic,
        body: %PublishRequest{messages: messages}
      )
    end
  end

  defp build_messages(count), do: Enum.map(1..count, &build_message/1)
  defp build_message(index), do: %PubsubMessage{data: Base.encode64("Message number #{index}")}
end
