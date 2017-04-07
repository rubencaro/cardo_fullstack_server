alias Plug.Conn
alias Cardo.Card

defmodule Cardo.Controller do
  @moduledoc """
  Controller code
  """

  @doc """
  Main SSE loop.
  Calls `send_data/2` for each Card in db.
  """
  def sse_loop(%Conn{} = conn) do
    case Card.one(%{}) do
      {:error, _} ->
        :timer.sleep(1000)
      card ->
        Conn.send_data(conn, card.doc._data)
        Card.destroy(card)
    end
    sse_loop(conn)
  end

  defp send_data(%Conn{} = conn, data) do
    msg = ~s|event: "message"\n\ndata: #{Poison.encode!(data)}\n\n|
    Conn.chunk(conn, msg)
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
