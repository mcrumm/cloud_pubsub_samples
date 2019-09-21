defmodule CloudPubsubSamples.Connections do
  @moduledoc """
  Conveniences for building Cloud Pub/Sub Tesla clients.
  """
  alias GoogleApi.PubSub.V1.Connection

  @scope "https://www.googleapis.com/auth/cloud-platform"
  @token_fetcher {__MODULE__, :fetch_token, [@scope]}

  def new_connection({mod, fun, args}) do
    with {:ok, token} <- apply(mod, fun, args) do
      {:ok, Connection.new(token)}
    end
  end

  def token_generator do
    Application.get_env(:cloud_pubsub_samples, :token_generator, @token_fetcher)
  end

  @doc false
  def fetch_token(scope \\ @scope) do
    with {:ok, %{token: token}} <- Goth.Token.for_scope(scope) do
      {:ok, token}
    end
  end
end
