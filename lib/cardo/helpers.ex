defmodule Cardo.Helpers do

  @moduledoc """
    require Cardo.Helpers, as: H  # the cool way
  """
  @doc """
    Convenience to get environment bits. Avoid all that repetitive
    `Application.get_env( :myapp, :blah, :blah)` noise.

    Use it as `H.env(:anyapp, :key, default)`

    You can add the default app to your config file:

    ```
      config :alfred, app: :myapp
    ```

    Then you can use it as `H.env(:key)` instead of `H.env(:myapp, :key)`
  """
  def env(key, default \\ nil), do: env(Application.get_env(:alfred, :app, :alfred), key, default)
  def env(app, key, default), do: Application.get_env(app, key, default)

  @doc """
  Spit to output any passed variable, with location information.

  If `sample` option is given, it should be a float between 0.0 and 1.0.
  Output will be produced randomly with that probability.

  Given `opts` will be fed straight into `inspect`. Any option accepted by it should work.
  """
  defmacro spit(obj \\ "", opts \\ []) do
    quote do
      opts = unquote(opts)
      obj = unquote(obj)
      opts = Keyword.put(opts, :env, __ENV__)

      Cardo.Helpers.maybe_spit(obj, opts, opts[:sample])
      obj  # chainable
    end
  end

  @doc false
  def maybe_spit(obj, opts, nil), do: do_spit(obj, opts)
  def maybe_spit(obj, opts, prob) when is_float(prob) do
    if :rand.uniform <= prob, do: do_spit(obj, opts)
  end
  def maybe_spit(obj, opts, prob) when is_function(prob) do
    case prob.(obj) do
      true -> do_spit(obj, opts)
      _ -> obj
    end
  end

  defp do_spit(obj, opts) do
    opts = Keyword.merge([pretty: true], opts)

    %{file: file, line: line} = opts[:env]
    name = Process.info(self())[:registered_name]
    chain = [:bright, :red, "\n\n#{file}:#{line}", :green,
        "\n   #{DateTime.utc_now |> DateTime.to_string}",
        :red, :normal, "  #{inspect self()}", :green, " #{name}"]

    msg = inspect(obj, opts)
    chain = chain ++ [:red, "\n\n#{msg}"]

    chain = chain ++ ["\n\n", :reset]

    chain |> IO.ANSI.format(true) |> IO.puts
  end

  @doc """
    Print to stdout a _TODO_ message, with location information.
  """
  defmacro todo(msg \\ "") do
    quote do
      %{file: file, line: line} = __ENV__
      [:yellow, "\nTODO: #{file}:#{line} #{unquote(msg)}\n", :reset]
      |> IO.ANSI.format(true)
      |> IO.puts
      :todo
    end
  end

  @doc """
    Print to stdout a _DEPRECATED_ message, with location information.
  """
  defmacro deprecated(msg \\ "") do
    quote do
      %{file: file, line: line} = __ENV__
      [:yellow, "\nDEPRECATED: #{file}:#{line} #{unquote(msg)}\n", :reset]
      |> IO.ANSI.format(true)
      |> IO.puts
      :deprecated
    end
  end

  @doc """
    Returns `{:error, reason}` if any given key is not in the given Keyword.
    Else returns given Keyword, so it can be chained using pipes.
  """
  def requires(args, required) when is_map(args) do
    keys = args |> Map.keys
    case requires(keys, required) do
      ^keys -> args # chainable
      x -> x
    end
  end
  def requires(args, required) when is_list(args) do
    keys = case Keyword.keyword?(args) do
        true -> args |> Keyword.keys
        false -> args
      end

    case do_requires(keys, required) do
      :ok -> args # chainable
      x -> x
    end
  end

  defp do_requires(keys, [required|rest]) do
    case required in keys do
      true -> do_requires(keys, rest)
      false -> {:error, "Required argument '#{required}' was not present in #{inspect(keys)}"}
    end
  end
  defp do_requires(_, []), do: :ok

  @doc """
  Exploding version of `requires/2`
  """
  def requires!(args, required) do
    case requires(args, required) do
      {:error, reason} -> raise(ArgumentError, reason)
      x -> x
    end
  end

  @doc """
  Get the value at given coordinates inside the given nested structure.
  The structure must be composed of `Map`, `Keyword` and `List`.

  If coordinates do not exist `nil` is returned.
  """
  def get_nested(data, []), do: data
  def get_nested(data, [key | rest]) when is_map(data) do
    data |> Map.get(key) |> get_nested(rest)
  end
  def get_nested([{_key, _value} | _rest] = data, [key | rest]) when is_atom(key) do
    data |> Keyword.get(key) |> get_nested(rest)
  end
  def get_nested(data, [key | rest]) when is_list(data) and is_integer(key) do
    data |> Enum.at(key) |> get_nested(rest)
  end
  def get_nested(_, _), do: nil
  def get_nested(data, keys, default), do: get_nested(data, keys) || default

  @doc """
  Put given `value` on given coordinates inside the given structure.
  The structure must be composed of `Map`, `Keyword` and `List`.
  Returns updated structure.

  `value` can be a function that will be run only when the value is needed.

  If coordinates do not exist, needed structures are created.
  """
  def put_nested(nil, [key], value) when is_integer(key) or is_atom(key),
    do: put_nested([], [key], value)
  def put_nested(nil, [key | _] = keys, value) when is_integer(key) or is_atom(key),
    do: put_nested([], keys, value)
  def put_nested(nil, [key], value),
    do: put_nested(%{}, [key], value)
  def put_nested(nil, keys, value),
    do: put_nested(%{}, keys, value)

  def put_nested(data, [key], value) when is_function(value),
    do: put_nested(data, [key], value.())
  def put_nested(data, [key], value) when is_map(data) do
    {_, v} = Map.get_and_update(data, key, &({&1, value}))
    v
  end
  def put_nested([], [key], value) when is_atom(key),
    do: Keyword.put([], key, value)
  def put_nested([{_key, _value} | _rest] = data, [key], value) when is_atom(key) do
    {_, v} = Keyword.get_and_update(data, key, &({&1, value}))
    v
  end
  def put_nested(data, [key], value) when is_list(data) and is_integer(key) do
    case Enum.count(data) <= key do
      true -> data |> grow_list(key + 1) |> put_nested([key], value)
      false -> List.update_at(data, key, fn(_) -> value end)
    end
  end
  # `data` is not a `Map`, `Keyword` or `List`, so it's already a replaceable value.
  def put_nested(_data, [key], value), do: put_nested(nil, [key], value)

  def put_nested(data, [key | rest], value) when is_map(data) do
    {_, v} = Map.get_and_update(data, key, &({&1, put_nested(&1, rest, value)}))
    v
  end
  def put_nested([{_key, _value} | _rest] = data, [key | rest], value) when is_atom(key) do
    {_, v} = Keyword.get_and_update(data, key, &({&1, put_nested(&1, rest, value)}))
    v
  end
  def put_nested(data, [key | rest] = keys, value) when is_list(data) and is_integer(key) do
    case Enum.count(data) <= key do
      true -> data |> grow_list(key + 1) |> put_nested(keys, value)
      false -> List.update_at(data, key, &put_nested(&1, rest, value))
    end
  end

  @doc """
  Updates given coordinates inside the given structure with given `fun`.
  The structure must be composed of `Map`, `Keyword` and `List`.
  Returns updated structure.

  `fun` must be a function. It will be passed the previous value, or `nil`.

  If coordinates do not exist, needed structures are created.
  """
  def update_nested(data, keys, fun) when is_function(fun),
    do: put_nested(data, keys, fun.(get_nested(data, keys)))

  @doc """
  Drops whatever is on given coordinates inside given structure.
  The structure must be composed of `Map, `Keyword` and `List`.
  Returns the updated structure.

  If coordinates do not exist nothing bad happens.

      iex> %{a: [%{b: 123}, "hey"]} |> Cardo.Helpers.drop_nested([:a, 0, :c])
      %{a: [%{b: 123}, "hey"]}
      iex> %{a: [%{b: 123, c: [:thing]}, "hey"]} |> Cardo.Helpers.drop_nested([:a, 0, :c])
      %{a: [%{b: 123}, "hey"]}
      iex> %{a: [%{b: 123, c: [:thing]}, "hey"]} |> Cardo.Helpers.drop_nested([:a])
      %{}

      iex> %{a: [[b: 123], "hey"]} |> Cardo.Helpers.drop_nested([:a, 0, :c])
      %{a: [[b: 123], "hey"]}
      iex> %{a: [[b: 123, c: [:thing]], "hey"]} |> Cardo.Helpers.drop_nested([:a, 0, :c])
      %{a: [[b: 123], "hey"]}

  """
  def drop_nested(data, [key]) when is_map(data), do: Map.drop(data, [key])
  def drop_nested(data, [key]) when is_list(data) and is_atom(key),
    do: Keyword.drop(data, [key])
  def drop_nested(data, [key]) when is_list(data), do: List.delete_at(data, key)
  def drop_nested(data, keys), do: drop_nested(data, keys, data, keys)

  def drop_nested(data, [key, last], orig, keys) do
    next = data |> get_nested([key])
    case next |> has_key?(last) do
      false -> orig
      true -> put_nested(orig, Enum.drop(keys, -1), drop_nested(next, [last]))
    end
  end
  def drop_nested(data, [key | rest], orig, keys) when is_map(data) do
    data |> Map.get(key) |> drop_nested(rest, orig, keys)
  end
  def drop_nested(data, [key | rest], orig, keys) when is_list(data) and is_atom(key) do
    data |> Keyword.get(key) |> drop_nested(rest, orig, keys)
  end
  def drop_nested(data, [key | rest], orig, keys) when is_list(data) do
    data |> Enum.at(key) |> drop_nested(rest, orig, keys)
  end

  @doc """
  Version of `Map.has_key?/2` that can also be used for `List` and `Keyword`.
  Useful when you must work with a combination of `Map`, `Keyword` and `List`

      iex> %{a: 1, b: 2} |> Cardo.Helpers.has_key?(:a)
      true
      iex> %{a: 1, b: 2} |> Cardo.Helpers.has_key?(:c)
      false

      iex> [a: 1, b: 2] |> Cardo.Helpers.has_key?(:a)
      true
      iex> [a: 1, b: 2] |> Cardo.Helpers.has_key?(:c)
      false

      iex> [:a, :b] |> Cardo.Helpers.has_key?(1)
      true
      iex> [:a, :b] |> Cardo.Helpers.has_key?(2)
      false

  """
  def has_key?(data, key) when is_map(data), do: Map.has_key?(data, key)
  def has_key?([{_key, _value} | _rest] = data, key) when is_atom(key),
    do: Keyword.has_key?(data, key)
  def has_key?(data, key) when is_list(data) and is_integer(key),
    do: Enum.count(data) > key

  @doc """
  Pushes given `thing` into a List on given coordinates inside given structure.
  The structure must be composed of `Map`, `Keyword` and `List`.
  Returns the updated structure.

  If a List already exists on given coordinates, `thing` is pushed onto it.
  If there is nothing on given coordinates, a single element List is created.
  If coordinates do not exist, needed structures are created.
  `{:error, reason}` is returned if there is anything other than a List on given
  coordinates, or anything else fails.

      iex> %{a: [%{b: 123}, "hey"]} |> Cardo.Helpers.push_nested([:a, 0, :c], :thing)
      %{a: [%{b: 123, c: [:thing]}, "hey"]}
      iex> %{a: [%{b: 123}, "hey"]} |> Cardo.Helpers.push_nested([:a], :thing)
      %{a: [%{b: 123}, "hey", :thing]}
      iex> %{a: %{b: 123}} |> Cardo.Helpers.push_nested([:a], :thing)
      {:error, :not_a_list}

      iex> [a: [[b: 123], "hey"]] |> Cardo.Helpers.push_nested([:a, 0, :c], :thing)
      [a: [[c: [:thing], b: 123], "hey"]]

  """
  def push_nested(nil, keys, value), do: put_nested(nil, keys, [value])
  def push_nested(data, [key], value) do
    case get_nested(data, [key]) do
      nil -> put_nested(data, [key], [value])
      list when is_list(list) -> put_nested(data, [key], list ++ [value])
      _ -> {:error, :not_a_list}
    end
  end
  def push_nested(data, [key | rest], value) when is_map(data) do
    {_, v} = Map.get_and_update(data, key, &({&1, push_nested(&1, rest, value)}))
    v
  end
  def push_nested(data, [key | rest], value) when is_list(data) and is_atom(key) do
    {_, v} = Keyword.get_and_update(data, key, &({&1, push_nested(&1, rest, value)}))
    v
  end
  def push_nested(data, [key | rest] = keys, value) when is_list(data) and is_integer(key) do
    case Enum.at(data, key) do
      nil -> data |> grow_list(key + 1) |> push_nested(keys, value)
      _ -> List.update_at(data, key, &push_nested(&1, rest, value))
    end
  end

  @doc """
  Just like `put_nested/3` but only replaces the value on last coordinate level
  if there is no previous value. Intermediate levels are traversed or created as needed.
  The structure must be composed of `Map`, `Keyword` and `List`.
  """
  def merge_nested(nil, keys, value), do: put_nested(nil, keys, value)
  def merge_nested(data, [key], value) do
    case get_nested(data, [key]) do
      nil -> put_nested(data, [key], value)
      _ -> data
    end
  end
  def merge_nested(data, [key | rest], value) when is_map(data) do
    {_, v} = Map.get_and_update(data, key, &({&1, merge_nested(&1, rest, value)}))
    v
  end
  def merge_nested(data, [key | rest], value) when is_list(data) and is_atom(key) do
    {_, v} = Keyword.get_and_update(data, key, &({&1, merge_nested(&1, rest, value)}))
    v
  end
  def merge_nested(data, [key | rest] = keys, value) when is_list(data) and is_integer(key) do
    case Enum.at(data, key) do
      nil -> data |> grow_list(key + 1) |> merge_nested(keys, value)
      _ -> List.update_at(data, key, &merge_nested(&1, rest, value))
    end
  end

  @doc """
  Applies given mapping function to given enumerable
  only if given expression is `true`.
  """
  def map_if(data, expression, map_fun) when is_function(expression) do
    map_if(data, expression.(), map_fun)
  end
  def map_if(data, expression, map_fun) do
    case expression do
      true -> Enum.map(data, &(map_fun.(&1)))
      _ -> data
    end
  end

  @doc """
  Fills given list with nils until it is of the given length

    iex> require Cardo.Helpers, as: H
    iex> H.grow_list([], 3)
    [nil, nil, nil]
    iex> H.grow_list([1, 2], 3)
    [1, 2, nil]
    iex> H.grow_list([1, 2, 3], 3)
    [1, 2, 3]
    iex> H.grow_list([1, 2, 3, 4], 3)
    [1, 2, 3, 4]

  """
  def grow_list(list, length) do
    count = length - Enum.count(list)
    case count > 0 do
      true -> list ++ List.duplicate(nil, count)
      false -> list
    end
  end

  @doc """
    Tell the world outside we're alive
  """
  def alive_loop(app_name, opts \\ []) do
    # register the name if asked
    if opts[:name], do: Process.register(self(), opts[:name])

    :timer.sleep 5_000
    tmp_path = :tmp_path |> env("tmp") |> Path.expand
    {_, _, version} = Application.started_applications |> Enum.find(&(match?({^app_name, _, _}, &1)))
    "echo '#{version}' > #{tmp_path}/alive" |> to_charlist |> :os.cmd
    alive_loop(app_name)
  end

  @doc """
  Add given `label` to given `thing`.
  Useful for piping.

      iex> %{my: :thing} |> Cardo.Helpers.label
      {:ok, %{my: :thing}}
      iex> %{my: :thing} |> Cardo.Helpers.label(:error)
      {:error, %{my: :thing}}

  """
  def label(thing, label \\ :ok), do: {label, thing}

end
