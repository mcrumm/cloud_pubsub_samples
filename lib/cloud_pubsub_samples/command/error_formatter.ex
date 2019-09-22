defmodule CloudPubsubSamples.Command.ErrorFormatter do
  @moduledoc false

  alias CloudPubsubSamples.Model.ErrorResponse

  def format(cmd, {:error, %Tesla.Env{} = env}), do: format(cmd, env)
  def format(cmd, %Tesla.Env{} = env), do: format(cmd, decode!(env))
  def format(cmd, %ErrorResponse{error: error}), do: format(cmd, error)

  def format(cmd, error) do
    """
    Command: #{cmd}
    Error: #{inspect(error, pretty: true)}
    """
  end

  def decode!(%Tesla.Env{status: status} = env) when status not in 200..299 do
    %{body: body} = env
    Poison.decode!(body, as: %ErrorResponse{})
  end

  def decode!(response), do: response
end
