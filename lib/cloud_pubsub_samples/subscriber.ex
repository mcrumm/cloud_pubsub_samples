defmodule CloudPubsubSamples.Subscriber do
  @moduledoc false
  alias CloudPubsubSamples.Api.Subscriptions

  @doc """
  Lists subscriptions for the given project.
  """
  defdelegate list_in_project(project),
    to: Subscriptions,
    as: :list

  @doc """
  Lists subscriptions within a given topic.
  """
  defdelegate list_in_topic(project, topic),
    to: Subscriptions,
    as: :list

  @doc """
  Creates a new subscription for a Pub/Sub topic.
  """
  defdelegate create_subscription(project, topic, subscription),
    to: Subscriptions,
    as: :create

  @doc """
  Deletes a subscription from the current project.
  """
  defdelegate delete_subscription(project, subscription),
    to: Subscriptions,
    as: :delete
end
