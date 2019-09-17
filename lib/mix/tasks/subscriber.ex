defmodule Mix.Tasks.Subscriber do
  use Mix.Task
  alias CloudPubsubSamples.Project

  @shortdoc "Commands for Cloud Pub/Sub Subscriptions"

  @moduledoc """
  Commands for interacting with Cloud Pub/Sub subscriptions.

  **Commands**

    * `create`  - Creates a named subscription for the given topic.
       Usage: `mix subscriber create <topic> <subscription_name>`
    * `delete`  - Deletes a named subscription from the current project.
       Usage: `mix subscriber delete <subscription_name>`
    * `list_in_topic` - Lists subscriptions within the given topic.
       Usage: `mix subscriber list_in_topic <topic>`
    * `list_in_project` - Lists subscriptions within the current project.
       Usage: `mix subscriber list_in_project`
    * `receive` - Starts listening for messages on the given subscription.
       The `--no-halt` flag is automatically added.
       Usage: `mix subscriber receive <subscription_name>`
  """

  @impl true
  @doc false
  def run(["create", topic, subscription | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, subscription} <- Project.create_subscription(project, topic, subscription) do
      Mix.shell().info("Created subscription #{subscription.name}")
      :ok
    else
      {:error, reason} ->
        raise "Failed to created subscription, reason: #{inspect(reason)}"
    end
  end

  def run(["delete", subscription | _args]) do
    with {:ok, project} <- Project.init(),
         :ok <- Project.delete_subscription(project, subscription) do
      Mix.shell().info("Deleted subscription #{Project.subscription_path(project, subscription)}")
      :ok
    else
      {:error, reason} ->
        raise "Failed to created subscription, reason: #{inspect(reason)}"
    end
  end

  def run(["list_in_project" | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, %{subscriptions: subs}} when is_list(subs) <- Project.list_subscriptions(project) do
      shell = Mix.shell()
      Enum.each(subs, fn sub -> shell.info(sub.name) end)
      :ok
    else
      {:error, reason} ->
        raise "Failed to created subscription, reason: #{inspect(reason)}"

      _ ->
        {:ok, []}
    end
  end

  def run(["list_in_topic", topic | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, %{subscriptions: subs}} when is_list(subs) <-
           Project.list_subscriptions(project, topic) do
      shell = Mix.shell()
      Enum.each(subs, fn sub -> shell.info(sub) end)
      :ok
    else
      {:error, reason} ->
        raise "Failed to created subscription, reason: #{inspect(reason)}"

      _ ->
        {:ok, []}
    end
  end

  def run(["receive", subscription | args]) do
    with {:ok, path} <- Project.init_for_receive(subscription) do
      Application.put_env(:cloud_pubsub_samples, :subscription_path, path, persistent: true)
      Mix.shell().info("Listening for messages on #{path} - Press Ctrl+C to exit")

      Mix.Tasks.Run.run(run_args() ++ args)
      :ok
    else
      {:error, reason} ->
        raise reason
    end
  end

  def run(_) do
    Mix.shell().info("""
    usage: mix subscriber [-h] {create, list_in_topic, list_in_project, receive} ...
    """)
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end
end
