defmodule Raspi3.Mixfile do
  use Mix.Project

  def project do
    [
      app: :raspi3,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Raspi3, []},
      extra_applications: [:logger,:logger_file_backend, :ex_aws, :hackney, :poison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_uart, "~> 1.2"},
      {:picam, "0.3.0"},
      {:slack, "~> 0.12.0"},
      {:logger_file_backend, "~> 0.0.10"},
      {:arc, "~> 0.8.0"},
      {:ex_aws, "~> 1.1"},
      {:hackney, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:sweet_xml, "~> 0.6"}
    ]
  end
end
