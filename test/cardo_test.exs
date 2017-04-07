require Cardo.Helpers, as: H
alias Cardo.Helpers.Test, as: TH
alias Cardo.Card

defmodule CardoTest do
  use ExUnit.Case

  setup do
    Card.create(%{"placeholder": true})
    Xarango.Document.__destroy_all
    :ok
  end

  test "SSE connects" do
    res = TH.get("/sse", loops: 1, sleep_msec: 10)
    assert res.status == 200
    assert res.state == :chunked
    assert {"content-type", "text/event-stream"} in res.resp_headers
  end

  test "SSE sends data from db" do
    data = %{"test" => "data"}
    msg = ~s|event: "message"\n\ndata: #{Poison.encode!(data)}\n\n|
    Card.create(data)
    res = H.wait_for(fn -> TH.get("/sse", loops: 5, sleep_msec: 100) end)
    assert res.resp_body == msg
  end

  test "Create entry" do
    body = %{msg: "heyhey"}
    res = TH.post("/entry", Poison.encode!(body))
    assert res.status == 200

    H.wait_for(fn ->
      match?(%Card.Collection{doc: %Xarango.Document{_data: ^body}}, Card.one(%{}))
    end)
  end
end
