defmodule CloudPubsubSamples.Command do
  @moduledoc """
  A generic Mix Task for building Pub/Sub commands.
  """

  @callback run(project :: String.t(), args :: [binary()]) :: no_return

  defmacro __using__(_) do
    quote do
      use Mix.Task
      @behaviour unquote(__MODULE__)

      def run(args) do
        CloudPubsubSamples.Command.run(__MODULE__, args)
      end
    end
  end

  @doc """
  Dynamic dispatcher for Pub/Sub commands.
  """
  @spec run(task :: module(), args :: [binary]) :: no_return
  def run(task, args) do
    case CloudPubsubSamples.Command.init() do
      {:ok, project} ->
        task.run(project, args)

      {:error, reason} ->
        Mix.shell().error(reason)
    end
  end

  @doc false
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
end
