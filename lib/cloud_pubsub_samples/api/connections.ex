defmodule CloudPubsubSamples.Api.Connections do
  @moduledoc false
  alias GoogleApi.PubSub.V1.Connection
  alias Tesla.Adapter.Hackney

  @scope "https://www.googleapis.com/auth/cloud-platform"
  @token_fetcher {__MODULE__, :fetch_token, [@scope]}

  def new_connection({mod, fun, args}, hackney_opts \\ []) do
    with {:ok, token} <- apply(mod, fun, args) do
      conn = build_conn(token, hackney_opts)
      {:ok, conn}
    end
  end

  defp build_conn(token, hackney_opts) do
    client = Connection.new(token)
    %{adapter: adapter} = Tesla.client([], {Hackney, hackney_opts})
    %{client | adapter: adapter}
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
