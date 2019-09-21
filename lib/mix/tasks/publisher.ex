defmodule Mix.Tasks.Publisher do
  use Mix.Task
  alias CloudPubsubSamples.Project

  @shortdoc "Commands for Cloud Pub/Sub Topics"

  @moduledoc """
  Commands for interacting with Cloud Pub/Sub topics.

  **Commands**

    * `list` -   Lists all Pub/Sub topics on the current project.
                 Usage: `mix publisher list`
    * `create` - Creates a Pub/Sub topic
                 Usage: `mix publisher create <topic_name>`
    * `delete` - Deletes a Pub/Sub topic
                 Usage: `mix publisher delete <topic_name>`
  """

  @impl true
  @doc false
  def run(["create", topic_name | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, topic} <- Project.create_topic(project, topic_name) do
      Mix.shell().info("Created topic #{topic.name}")
      :ok
    else
      {:error, reason} ->
        raise "Error creating topic, reason: #{inspect(reason)}"
    end
  end

  def run(["delete", topic_name | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, _topic} <- Project.delete_topic(project, topic_name) do
      Mix.shell().info("Deleted topic #{topic_name}")
      :ok
    else
      {:error, reason} ->
        raise "Error deleting topic, reason: #{inspect(reason)}"
    end
  end

  def run(["list" | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, topics} <- Project.list_topics(project) do
      topics |> Enum.map(fn topic -> IO.puts(topic.name) end)
      :ok
    else
      {:error, reason} ->
        raise "Error listing topics, reason: #{inspect(reason)}"
    end
  end

  def run(["publish" | args]) do
    Mix.Tasks.Publisher.Publish.run(args)
  end
end
