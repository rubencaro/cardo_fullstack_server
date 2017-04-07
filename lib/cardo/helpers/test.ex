alias Cardo.Router
alias Plug.Conn

defmodule Cardo.Helpers.Test do
  @moduledoc """
  Helpers for testing time
  """
  use Plug.Test

  def get(path, opts \\ []) do
    :get
    |> conn(path)
    |> put_opts(opts)
    |> Router.call([])
  end

  def post(path, data, opts \\ []) do
    :post
    |> conn(path, data)
    |> put_req_header("content-type", "application/json")
    |> put_opts(opts)
    |> Router.call([])
  end

  defp put_opts(%Conn{} = conn, opts) do
    Enum.reduce(opts, conn, fn({k, v}, acc) ->
      acc
      |> put_req_header("cardo-opt-#{k}", "#{v}")
    end)
  end
end
