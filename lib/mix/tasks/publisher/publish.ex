defmodule Mix.Tasks.Publisher.Publish do
  use CloudPubsubSamples.Command
  @shortdoc "Publishes messages to a Cloud Pub/Sub topic"

  @moduledoc """
  Publishes messages to a Google Cloud Pub/Sub topic.

  ## Usage

        mix publisher.publish topic_name
        mix publisher.publish topic_name -n 100
  """

  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, args) do
    with {:ok, topic, opts} <- parse_args(args),
         {:ok, message_ids} <- Publisher.publish(project, topic, opts) do
      shell = Mix.shell()

      for message_id <- message_ids do
        shell.info("Published message #{message_id}")
      end
    else
      {:error, reason} ->
        Mix.shell().error("Error publishing messages, reason: #{inspect(reason)}")
    end
  end

  defp parser_opts, do: [aliases: [n: :count], strict: [count: :integer]]

  defp parse_args(args) do
    case OptionParser.parse(args, parser_opts()) do
      {_, [], _} ->
        {:error, "topic is a required argument"}

      {[count: n], [topic | _], _} when is_integer(n) and n > 0 ->
        {:ok, topic, num_messages: n}

      {_, [topic | _], _} ->
        {:ok, topic, []}
    end
  end
end
