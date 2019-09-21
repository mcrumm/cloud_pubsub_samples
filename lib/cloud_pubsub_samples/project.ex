defmodule CloudPubsubSamples.Project do
  @moduledoc """
  Path helpers for Cloud Pub/Sub projects.
  """

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
