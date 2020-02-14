defmodule CloudPubsubSamples.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloud_pubsub_samples,
      version: "1.0.0-dev",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CloudPubsubSamples.Application, []}
    ]
  end

  defp deps do
    [
      {:broadway_cloud_pub_sub, "~> 0.6.0-dev",
       git: "https://github.com/dashbitco/broadway_cloud_pub_sub.git"},
      {:goth, "~> 1.0"},
      {:ex_doc, "~> 0.21", only: :docs}
    ]
  end

  defp docs do
    [
      main: "CloudPubsubSamples",
      source_ref: "master",
      source_url: "https://github.com/mcrumm/cloud_pubsub_samples",
      output: "docs"
    ]
  end
end
