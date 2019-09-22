defmodule CloudPubsubSamples.Publisher do
  @moduledoc false
  alias CloudPubsubSamples.Api.Topics
  alias GoogleApi.PubSub.V1.Model.PubsubMessage

  @doc """
  Lists topics for the given project.
  """
  defdelegate list_topics(project), to: Topics, as: :list

  @doc """
  Creates a new Pub/Sub topic on the given project.
  """
  defdelegate create_topic(project, topic), to: Topics, as: :create

  @doc """
  Deletes a topic on the given project.
  """
  defdelegate delete_topic(project, subscription), to: Topics, as: :delete

  @doc """
  Publishes messages to the given project/topic.
  """
  def publish(project, topic, opts \\ []) do
    num_messages = Keyword.get(opts, :num_messages, 10)
    messages = build_messages(num_messages)

    Topics.publish(project, topic, messages)
  end

  defp build_messages(count), do: Enum.map(1..count, &build_message/1)
  defp build_message(index), do: %PubsubMessage{data: Base.encode64("Message number #{index}")}
end
