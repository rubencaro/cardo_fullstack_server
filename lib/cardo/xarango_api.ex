defmodule Cardo.Xarango do
  @moduledoc """
  Helpers to interact with Xarango
  """

  defmacro __using__(_options) do
    quote do
      import Cardo.Xarango
      use Xarango.Domain.Document
    end
  end

  defmacro run(fname, args) do
    quote do
      do_run(unquote(__MODULE__), fname, args)
    end
  end

  def do_run(mod, fname, args) do
    try do
      apply(mod, fname, args)
    rescue
      e in [Xarango.Error] -> {:error, inspect(e)}
    end
  end
end
