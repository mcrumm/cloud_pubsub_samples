defmodule CloudPubsubSamples.Model.ErrorResponse do
  use GoogleApi.Gax.ModelBase

  @type t :: %__MODULE__{
          :error => CloudPubsubSamples.Model.Error
        }

  field(:error, as: CloudPubsubSamples.Model.Error)
end

defimpl Poison.Decoder, for: CloudPubsubSamples.Model.ErrorResponse do
  def decode(value, options) do
    CloudPubsubSamples.Model.ErrorResponse.decode(value, options)
  end
end

defimpl Poison.Encoder, for: CloudPubsubSamples.Model.ErrorResponse do
  def encode(value, options) do
    GoogleApi.Gax.ModelBase.encode(value, options)
  end
end
