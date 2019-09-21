defmodule Mix.Tasks.Publisher.List do
  use CloudPubsubSamples.Command
  @shortdoc "Lists Cloud Pub/Sub topics"

  @moduledoc """
  Lists the Google Cloud Pub/Sub topic on the current project.
  """
  alias CloudPubsubSamples.Publisher

  @impl true
  def run(project, _args) do
    case Publisher.list_topics(project) do
      {:ok, topics} ->
        shell = Mix.shell()
        shell.info("Listing topics for projects/#{project}:")
        Enum.each(topics, fn topic -> shell.info(topic.name) end)
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Error listing topics, reason: #{inspect(reason)}
        """)
    end
  end
end
