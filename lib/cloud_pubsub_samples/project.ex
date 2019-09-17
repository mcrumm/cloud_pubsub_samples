defmodule CloudPubsubSamples.Project do
  @moduledoc false
  alias GoogleApi.PubSub.V1.Api.Projects
  alias GoogleApi.PubSub.V1.Connection

  @doc """
  Initializes the project and returns the Project ID.
  """
  def init do
    with {:ok, _} <- Application.ensure_all_started(:goth),
         {:ok, project} <- Goth.Config.get(:project_id) do
      {:ok, project}
    else
      {:error, {app, reason}} ->
        {:error, "#{inspect(app)} failed to start, reason: #{inspect(reason)}"}

      _ ->
        {:error, "Could not find Google Project ID. Check your Goth configuration."}
    end
  end

  @doc """
  Initializes for receiving a subscription, returning a subscription path.
  """
  def init_for_receive(subscription) do
    with {:ok, project} <- init() do
      {:ok, subscription_path(project, subscription)}
    end
  end

  @doc """
  Lists Pub/Sub topics for the given project.
  """
  def list_topics(project) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, %{topics: topics}} when is_list(topics) <-
           Projects.pubsub_projects_topics_list(conn, project) do
      {:ok, topics}
    else
      {:error, _} = err -> err
      _ -> {:ok, []}
    end
  end

  @doc """
  Creates a new Pub/Sub topic.
  """
  def create_topic(project, topic_name) do
    with {:ok, conn} <- new_connection(token_generator()) do
      Projects.pubsub_projects_topics_create(
        conn,
        project,
        topic_name
      )
    end
  end

  @doc """
  Creates a new subscription for a Pub/Sub topic.
  """
  def create_subscription(project, topic, subscription) do
    with {:ok, conn} <- new_connection(token_generator()) do
      Projects.pubsub_projects_subscriptions_create(
        conn,
        project,
        subscription,
        body: %{topic: topic_path(project, topic)}
      )
    end
  end

  @doc """
  Deletes a subscription from the current project.
  """
  def delete_subscription(project, subscription) do
    with {:ok, conn} <- new_connection(token_generator()),
         {:ok, _} <-
           Projects.pubsub_projects_subscriptions_delete(
             conn,
             project,
             subscription
           ) do
      :ok
    end
  end

  @doc """
  Lists subscriptions for the current project.
  """
  def list_subscriptions(project) do
    with {:ok, conn} <- new_connection(token_generator()) do
      Projects.pubsub_projects_subscriptions_list(
        conn,
        project
      )
    end
  end

  @doc """
  Lists subscriptions for a given topic
  """
  def list_subscriptions(project, topic) do
    with {:ok, conn} <- new_connection(token_generator()) do
      Projects.pubsub_projects_topics_subscriptions_list(
        conn,
        project,
        topic
      )
    end
  end

  @doc """
  Deletes a Pub/Sub topic.
  """
  def delete_topic(project, topic_name) do
    with {:ok, conn} <- new_connection(token_generator()) do
      Projects.pubsub_projects_topics_delete(
        conn,
        project,
        topic_name
      )
    end
  end

  @token_fetcher {__MODULE__, :fetch_token, []}

  defp new_connection({mod, fun, args}) do
    with {:ok, token} <- apply(mod, fun, args) do
      {:ok, Connection.new(token)}
    end
  end

  defp token_generator do
    Application.get_env(:cloud_pubsub_samples, :token_generator, @token_fetcher)
  end

  @doc false
  @scope "https://www.googleapis.com/auth/cloud-platform"
  def fetch_token do
    with {:ok, %{token: token}} <- Goth.Token.for_scope(@scope) do
      {:ok, token}
    end
  end

  @doc """
  Returns an absolute path for a Cloud Pub/Sub subscription.
  """
  def subscription_path(project, subscription) do
    "projects/#{project}/subscriptions/#{subscription}"
  end

  @doc """
  Returns an absolute path for a Cloud Pub/Sub topic.
  """
  def topic_path(project, topic) do
    "projects/#{project}/topics/#{topic}"
  end
end
