defmodule Mix.Tasks.Subscriber.ListInProject do
  use CloudPubsubSamples.Command
  @shortdoc "Lists Cloud Pub/Sub subscriptions for the current project"

  @moduledoc """
  Lists the Google Cloud Pub/Sub subscriptions for all topics in the current project.

  ## Usage

        mix subscriber.list_in_project
  """
  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, _) do
    with {:ok, subscriptions} <- Subscriber.list_in_project(project) do
      shell = Mix.shell()
      shell.info("Listing subscriptions for projects/#{project}:")

      Enum.each(subscriptions, fn s -> shell.info(s.name) end)
      :ok
    end
  end
end
