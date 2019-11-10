defmodule CloudPubsubSamples.Api.Topics do
  @moduledoc false
  import CloudPubsubSamples.Api.Connections

  import GoogleApi.PubSub.V1.Api.Projects,
    only: [
      pubsub_projects_topics_create: 3,
      pubsub_projects_topics_delete: 3,
      pubsub_projects_topics_list: 2,
      pubsub_projects_topics_publish: 4
    ]

  alias GoogleApi.PubSub.V1.Model.{PublishRequest, PubsubMessage}

  @max_messages_per_request 1_000

  @doc """
  Lists Pub/Sub topics for the given project.
  """
  def list(project) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, response} <- pubsub_projects_topics_list(conn, project) do
      %{topics: topics} = response
      {:ok, topics || []}
    end
  end

  @doc """
  Creates a new Pub/Sub topic for the given project.
  """
  def create(project, topic_name) do
    with {:ok, conn} <- new_connection(token_generator()) do
      pubsub_projects_topics_create(conn, project, topic_name)
    end
  end

  @doc """
  Deletes a Pub/Sub topic.
  """
  def delete(project, topic_name) do
    with {:ok, conn} <- new_connection(token_generator()) do
      pubsub_projects_topics_delete(conn, project, topic_name)
    end
  end

  @doc """
  Publishes message(s) to a Pub/Sub topic.
  """
  def publish(project, topic, %PubsubMessage{} = message) do
    publish(project, topic, [message])
  end

  def publish(project, topic, messages) do
    case new_connection(token_generator()) do
      {:ok, conn} -> publish_messages(conn, {project, topic}, messages)
      error -> error
    end
  end

  defp publish_messages(conn, project_info, messages) do
    {:ok,
     messages
     |> Stream.chunk_every(@max_messages_per_request)
     |> Stream.flat_map(fn batch ->
       case do_publish_messages(conn, project_info, batch) do
         {:ok, message_ids} -> message_ids
         _ -> []
       end
     end)}
  end

  defp do_publish_messages(conn, {project, topic}, messages) do
    case pubsub_projects_topics_publish(
           conn,
           project,
           topic,
           body: %PublishRequest{messages: messages}
         ) do
      {:ok, %{messageIds: message_ids}} -> {:ok, message_ids}
      other -> other
    end
  end
end
