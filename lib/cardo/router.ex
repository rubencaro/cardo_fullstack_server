require Cardo.Helpers, as: H

defmodule Cardo.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :cardo
  use Plug.ErrorHandler

  plug Plug.Logger, log: :debug
  plug Plug.Static, at: "/", from: :cardo

  plug :match

  # after match, before dispatch
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass:  ["*/*"],
    json_decoder: Poison

  plug :dispatch

  post "/entry" do
    Cardo.Card.create(conn.params)
    send_resp(conn, 200, "")
  end

  get "/sse" do
    conn
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    |> sse_loop
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    H.spit conn
    send_resp(conn, conn.status, "Something went wrong")
  end

  defp sse_loop(%Plug.Conn{} = conn) do
    case get_one_card() do
      nil -> :timer.sleep(1000)
      card ->
        send_data(conn, card.doc._data)
        destroy_card(card)
    end
    sse_loop(conn)
  end

  defp send_data(%Plug.Conn{} = conn, data) do
    msg = ~s|event: "message"\n\ndata: #{Poison.encode!(data)}\n\n|
    chunk(conn, msg)
  end

end
