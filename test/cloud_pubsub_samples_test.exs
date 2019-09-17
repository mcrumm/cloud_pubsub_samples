defmodule CloudPubsubSamplesTest do
  use ExUnit.Case
  doctest CloudPubsubSamples

  test "greets the world" do
    assert CloudPubsubSamples.hello() == :world
  end
end
