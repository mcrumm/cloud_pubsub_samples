defmodule CloudPubsubSamples.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :cloud_pubsub_samples,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CloudPubsubSamples.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway_cloud_pub_sub, "~> 0.4.0"},
      {:goth, "~> 1.0"},
      {:ex_doc, "~> 0.21", only: :docs}
    ]
  end

  defp docs do
    [
      main: "CloudPubsubSamples",
      source_ref: "master",
      source_url: "https://github.com/mcrumm/cloud_pubsub_samples"
    ]
  end
end
