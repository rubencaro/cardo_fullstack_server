require Cardo.Helpers, as: H
alias Cardo.Controller

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
    Controller.save_entry(conn)
  end

  get "/sse" do
    conn
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    |> Controller.sse_loop
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    H.spit conn
    send_resp(conn, conn.status, "Something went wrong")
  end
end
