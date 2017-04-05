require Cardo.Helpers, as: H

defmodule Cardo.Test.HelpersTest do
  use ExUnit.Case, async: true
  doctest H

  test "get_nested" do
    assert 3 == H.get_nested %{a: [1, 2, [1, 2, %{b: [a: 3, b: 8]}]]}, [:a, 2, 2, :b, :a]
    assert nil == H.get_nested %{a: [1, 2, [1, 2, %{b: [a: 3, b: 8]}]]}, [:a, 2, 3, :b, :a]
    assert 3 == H.get_nested %{a: [a: 2, b: [1, 2, %{b: [a: 3, b: 8]}]]}, [:a, :b, 2, :b, :a]
    assert nil == H.get_nested %{a: [a: 2, b: [1, 2, %{b: [a: 3, b: 8]}]]}, [:a, :c, 2, :b, :a]
  end

  defmodule A do
    defstruct [a: 123, b: nil, c: %{}]
  end

  test "put_nested" do
    o = %{a: [a: 1, b: [1, 2, %{b: 3}]]}
    assert %{a: [a: 1, b: [1, 2, %{b: ["c", "d"]}]]} == H.put_nested o, [:a, :b, 2, :b], ["c", "d"]
    assert %{a: [a: 1, b: [1, 2, "ya"]]} == H.put_nested o, [:a, :b, 2], "ya"
    assert %{a: [a: 1, b: [1, [nil, nil, "ya"], %{b: 3}]]} == H.put_nested o, [:a, :b, 1, 2], "ya"
    assert %{a: [a: 1, b: [1, [c: "ya"], %{b: 3}]]} == H.put_nested o, [:a, :b, 1, :c], "ya"
    assert %{a: [a: 1, b: [1, 2, %{b: 3, c: 4}]]} == H.put_nested o, [:a, :b, 2, :c], fn() -> 4 end

    # with structs too
    o = %A{a: [1, 2, [3, 4]], c: %{abc: 123}}
    assert %A{a: [1, 2, [3, 4]], c: %{abc: 123, cde: 234}} == H.put_nested o, [:c, :cde], 234
    assert %A{a: [1, 2, [3, 4]], c: %{abc: [5, 6]}} == H.put_nested o, [:c, :abc], [5, 6]
  end

  test "merge_nested" do
    o = %{a: [1, 2, [1, 2, %{b: 3}]]}
    assert %{a: [1, 2, [1, 2, %{b: 3}]]} == H.merge_nested o, [:a, 2, 2, :b], "ya"
    assert %{a: [1, 2, [1, 2, %{b: 3, c: "ya"}]]} == H.merge_nested o, [:a, 2, 2, :c], "ya"

    o = [a: [1, 2, %{a: 2, b: [a: 3]}]]
    assert [a: [1, 2, %{a: 2, b: [a: 3]}]] == H.merge_nested o, [:a, 2, :b, :a], "ya"
    assert [a: [1, 2, %{a: 2, b: [c: "ya", a: 3]}]] == H.merge_nested o, [:a, 2, :b, :c], "ya"

    # with structs too
    o = %A{a: [1, 2, [3, 4]], c: %{abc: 123}}
    assert %A{a: [1, 2, [3, 4]], c: %{abc: 123}} == H.merge_nested o, [:c], 234
    assert %A{a: [1, 2, [3, 4]], c: %{abc: 123, cde: 234}} == H.merge_nested o, [:c, :cde], 234
    assert %A{a: [1, 2, [3, 4]], c: %{abc: 123, cde: [3, 4]}} == H.merge_nested o, [:c, :cde], [3, 4]
    assert %A{a: [1, 2, [3, 4]], c: %{abc: 123}} == H.merge_nested o, [:c, :abc], [5, 6]
  end

  test "update_nested" do
    o = %{a: [%{b: 123}, "hey"]}

    # equivalent to `put_nested`
    assert %{a: [%{b: 123, c: [nil, nil, 18]}, "hey"]} == H.update_nested(o, [:a, 0, :c, 2], fn(_) -> 18 end)
    assert %{a: ["anything", "hey"]} == H.update_nested(o, [:a, 0], fn(_) -> "anything" end)
    assert %{a: [%{b: 125}, "hey"]} == H.update_nested(o, [:a, 0, :b], &(&1 + 2))

    o = [a: [d: %{b: 123}, e: "hey"]]
    assert [a: [d: %{b: 125}, e: "hey"]] == H.update_nested(o, [:a, :d, :b], &(&1 + 2))
  end

  test "map_if" do
    o = ["", nil, 123]
    assert ^o = H.map_if(o, false, &to_string(&1))
    assert ^o = H.map_if(o, fn-> false end, &to_string(&1))
    assert ["", "", "123"] = H.map_if(o, true, &to_string(&1))
    assert ["", "", "123"] = H.map_if(o, fn-> true end, &to_string(&1))
  end

end
