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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_uart, "~> 1.2"},
      {:slack, "~> 0.12.0"}
    ]
  end
end
