defmodule CloudPubsubSamples.Api.Topics do
  import CloudPubsubSamples.Api.Connections

  import GoogleApi.PubSub.V1.Api.Projects,
    only: [
      pubsub_projects_topics_create: 3,
      pubsub_projects_topics_delete: 3,
      pubsub_projects_topics_list: 2,
      pubsub_projects_topics_publish: 4
    ]

  alias GoogleApi.PubSub.V1.Model.{PublishRequest, PubsubMessage}

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

  def publish(project, topic, messages) when is_list(messages) do
    with {:ok, conn} <- new_connection(token_generator()) do
      pubsub_projects_topics_publish(
        conn,
        project,
        topic,
        body: %PublishRequest{messages: messages}
      )
    end
  end
end
