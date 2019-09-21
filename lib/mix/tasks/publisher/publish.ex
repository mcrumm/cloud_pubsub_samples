defmodule Mix.Tasks.Publisher.Publish do
  @moduledoc false
  use Mix.Task
  alias CloudPubsubSamples.{Project, Publisher}

  def run([topic | _args]) do
    with {:ok, project} <- Project.init(),
         {:ok, response} <- Publisher.publish(project, topic) do
      %{messageIds: message_ids} = response

      shell = Mix.shell()

      Enum.each(message_ids, fn id ->
        puts(shell, :info, "Published Message #{id}")
      end)

      :ok
    else
      {:error, reason} ->
        puts(:error, "Error publishing messages, reason: #{inspect(reason)}")
    end
  end

  defp puts(shell \\ Mix.shell(), kind, message)
  defp puts(shell, :error, message), do: shell.error(message)
  defp puts(shell, :info, message), do: shell.info(message)
end
