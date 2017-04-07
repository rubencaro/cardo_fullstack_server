alias Plug.Conn
alias Cardo.Card
require Cardo.Helpers, as: H

defmodule Cardo.Controller do
  @moduledoc """
  Controller code
  """

  @doc """
  Main SSE loop.
  Calls `send_data/2` for each Card in db.
  """
  def sse_loop(%Conn{} = conn),
    do: sse_loop(conn, get_opts_from_headers(conn))
  def sse_loop(%Conn{} = conn, opts) do
    loops = H.parse_integer(opts[:loops]) || -1

    conn = sleep_or_consume(conn, opts)

    if loops == 1 do
      conn
    else
      opts = Keyword.put(opts, :loops, loops - 1)
      sse_loop(conn, opts)
    end
  end

  defp get_opts_from_headers(%Conn{} = conn) do
    conn.req_headers
    |> Enum.filter(fn{k, _} -> match?(<<"cardo-opt-", _ :: binary>>, k) end)
    |> Enum.map(fn{<<"cardo-opt-", opt :: binary>>, v} ->
      try do
        {String.to_existing_atom(opt), v}
      rescue
        ArgumentError -> false
      end
    end)
    |> Enum.filter(&(&1))
  end

  defp sleep_or_consume(%Conn{} = conn, opts) do
    sleep_msec = H.parse_integer(opts[:sleep_msec]) || 1000

    case Card.one(%{}) do
      {:error, _} ->
        :timer.sleep(sleep_msec)
        conn
      card ->
        conn = send_data(conn, card.doc._data)
        Card.destroy(card)
        conn
    end
  end

  defp send_data(%Conn{} = conn, data) do
    msg = ~s|event: "message"\n\ndata: #{Poison.encode!(data)}\n\n|
    {:ok, conn} = Conn.chunk(conn, msg)
    conn
  end

  @doc """
  Saves a new entry on db based on given `Conn`.
  Returns a 200 or a 500 response based on feedback from db.
  """
  def save_entry(%Conn{} = conn) do
    case Card.create(conn.params) do
      {:error, reason} ->
        Conn.send_resp(conn, 500, reason)
      _ ->
        Conn.send_resp(conn, 200, "OK")
    end
  end
end
