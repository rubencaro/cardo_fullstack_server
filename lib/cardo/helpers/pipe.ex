require Cardo.Helpers, as: H  # the cool way

defmodule Cardo.Helpers.Pipe do
  @moduledoc """
  Piping related helpers
  """

  @doc """
  The inverse of `merge` for `Map` or `Keyword`, best suited to apply some
  defaults in a pipable way.

  Ex:
    kw = gather_data
      |> transform_data
      |> H.Pipe.merge(k1: 1234, k2: 5768)
      |> here_i_need_defaults

  Instead of:
    kw1 = gather_data
      |> transform_data
    kw = [k1: 1234, k2: 5768]
      |> Keyword.merge(kw1)
      |> here_i_need_defaults

    iex> [a: 3] |> Cardo.Helpers.Pipe.merge(a: 4, b: 5)
    [b: 5, a: 3]
    iex> %{a: 3} |> Cardo.Helpers.Pipe.merge(%{a: 4, b: 5})
    %{a: 3, b: 5}

  """
  def merge(args, defs) when is_map(args) and is_map(defs) do
    defs |> Map.merge(args)
  end
  def merge(args, defs) when is_list(args) and is_list(defs) do
    defs |> Keyword.merge(args)
  end

  @doc """
  Labelled version of `merge`
  """
  def label_merge(args, defs) do
    H.deprecated "Use `H.label` to tuple-label responses."
    {:ok, merge(args, defs)}
  end

  @doc """
    The inverse of `put` for `Map` or `Keyword`, best suited to apply some
    defaults in a pipable way.

      iex> 3 |> Cardo.Helpers.Pipe.put(:a, [a: 4, b: 5])
      [a: 3, b: 5]
      iex> 3 |> Cardo.Helpers.Pipe.put(:a, %{a: 4, b: 5})
      %{a: 3, b: 5}

  """
  def put(val, key, data) when is_map(data), do: Map.put(data, key, val)
  def put(val, key, data) when is_list(data), do: Keyword.put(data, key, val)

  @doc """
  The pipe inverse of `get_nested/3`
  """
  def get_nested(keys, data), do: H.get_nested(data, keys)

  @doc """
  The pipe inverse of `put_nested/3`
  """
  def put_nested(val, keys, data), do: H.put_nested(data, keys, val)

  @doc """
  The pipe inverse of `merge_nested/3`
  """
  def merge_nested(val, keys, data), do: H.merge_nested(data, keys, val)

  @doc """
  The pipe inverse of `update_nested/3`
  """
  def update_nested(fun, keys, data), do: H.update_nested(data, keys, fun)

end
