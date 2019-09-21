defmodule Mix.Tasks.Subscriber.ListInProject do
  use CloudPubsubSamples.Command
  @shortdoc "Lists subscriptions for the current project"

  alias CloudPubsubSamples.Subscriber

  @impl true
  def run(project, _) do
    case Subscriber.list_in_project(project) do
      {:ok, subscriptions} ->
        shell = Mix.shell()
        shell.info("Listing subscriptions for projects/#{project}:")

        Enum.each(subscriptions, fn s -> shell.info(s.name) end)
        :ok

      {:error, reason} ->
        Mix.shell().error("""
        Failed to fetch subscriptions, reason: #{inspect(reason)}
        """)
    end
  end
end
