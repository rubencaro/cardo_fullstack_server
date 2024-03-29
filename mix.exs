defmodule Cardo.Mixfile do
  use Mix.Project

  def project do
    [app: :cardo,
     version: get_version_number(),
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: Cardo.Helpers.Cover, verbose: false, ignored: []],
     aliases: aliases()]
  end

  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: apps(Mix.env),
     mod: {Cardo.Application, []}]
  end

  defp apps(:dev), do: apps(:prod) ++ [:reprise]
  defp apps(_), do: [:logger, :cowboy, :plug, :xarango]

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:xarango, "~> 0.4"},
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:reprise, "~> 0.5", only: :dev}
    ]
  end

  # Get version number based on git commit
  #
  defp get_version_number do
    commit = :os.cmd('git rev-parse --short HEAD') |> to_string |> String.rstrip(?\n)
    v = "0.1.0+#{commit}"
    case Mix.env do
      :dev -> v <> "dev"
      _ -> v
    end
  end

  defp aliases do
    [test: ["test --cover"]]
  end

end
