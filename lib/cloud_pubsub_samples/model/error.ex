defmodule CloudPubsubSamples.Model.Error do
  @moduledoc false
  use GoogleApi.Gax.ModelBase

  @type t :: %__MODULE__{
          :code => integer(),
          :message => String.t(),
          :status => String.t()
        }

  field(:code, type: :integer)
  field(:message)
  field(:status)
end

defimpl Poison.Decoder, for: CloudPubsubSamples.Model.Error do
  def decode(value, options) do
    CloudPubsubSamples.Model.Error.decode(value, options)
  end
end

defimpl Poison.Encoder, for: CloudPubsubSamples.Model.Error do
  def encode(value, options) do
    GoogleApi.Gax.ModelBase.encode(value, options)
  end
end
