defmodule Lookup.Mixfile do
  use Mix.Project

  def project do
    [app: :lookup,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Lookup],
     deps: deps()]
  end

  defp deps do
    [{:ecto, "~> 2.0"},
    {:postgrex, "~> 0.11"},
    {:poison, "~> 3.0"}]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto, :postgrex],
     mod: {Lookup, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options

end
