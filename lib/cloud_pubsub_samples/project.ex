defmodule CloudPubsubSamples.Project do
  @moduledoc false

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
  Returns an absolute path for a Cloud Pub/Sub subscription.
  """
  def subscription_path(project, subscription) do
    "projects/#{project}/subscriptions/#{subscription}"
  end
end
