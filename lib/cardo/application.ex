defmodule Cardo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    greeting(Mix.env)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Cardo.Router, [],
                          [port: 4001, acceptors: 5,
                           protocol_options: [max_keepalive: :infinity]])
    ]

    opts = [strategy: :one_for_one, name: Cardo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp greeting(:test), do: :ok
  defp greeting(_) do
    [:bright, :green, """


 ▄████▄   ▄▄▄       ██▀███  ▓█████▄  ▒█████
▒██▀ ▀█  ▒████▄    ▓██ ▒ ██▒▒██▀ ██▌▒██▒  ██▒
▒▓█    ▄ ▒██  ▀█▄  ▓██ ░▄█ ▒░██   █▌▒██░  ██▒
▒▓▓▄ ▄██▒░██▄▄▄▄██ ▒██▀▀█▄  ░▓█▄   ▌▒██   ██░
▒ ▓███▀ ░ ▓█   ▓██▒░██▓ ▒██▒░▒████▓ ░ ████▓▒░
░ ░▒ ▒  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ▒▒▓  ▒ ░ ▒░▒░▒░
  ░  ▒     ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ▒  ▒   ░ ▒ ▒░
░          ░   ▒     ░░   ░  ░ ░  ░ ░ ░ ░ ▒
░ ░            ░  ░   ░        ░        ░ ░
░                            ░


""", :reset,
      " is listening on port ", :bright, "4001...\n\n", :reset]
    |> IO.ANSI.format |> IO.puts
  end
end
