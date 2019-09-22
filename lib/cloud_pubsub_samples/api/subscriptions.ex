defmodule CloudPubsubSamples.Api.Subscriptions do
  @moduledoc false
  import CloudPubsubSamples.Api.Connections
  import CloudPubsubSamples.Project

  import GoogleApi.PubSub.V1.Api.Projects,
    only: [
      pubsub_projects_subscriptions_create: 4,
      pubsub_projects_subscriptions_delete: 3,
      pubsub_projects_subscriptions_list: 2,
      pubsub_projects_topics_subscriptions_list: 3
    ]

  @doc """
  Lists subscriptions for the given project.
  """
  def list(project) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, response} <- pubsub_projects_subscriptions_list(conn, project) do
      %{subscriptions: subscriptions} = response
      {:ok, subscriptions || []}
    end
  end

  @doc """
  Lists subscriptions for the given topic.
  """
  def list(project, topic) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, response} <- pubsub_projects_topics_subscriptions_list(conn, project, topic) do
      %{subscriptions: subscriptions} = response
      {:ok, subscriptions || []}
    end
  end

  @doc """
  Creates a new subscription for a Pub/Sub topic.
  """
  def create(project, topic, subscription) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, response} <-
           pubsub_projects_subscriptions_create(
             conn,
             project,
             subscription,
             body: %{topic: topic_path(project, topic)}
           ) do
      {:ok, response}
    end
  end

  @doc """
  Deletes a subscription from the current project.
  """
  def delete(project, subscription) do
    with {:ok, conn} <- new_connection(token_generator()) do
      pubsub_projects_subscriptions_delete(conn, project, subscription)
    end
  end
end
