defmodule Cardo.Xarango do
  @moduledoc """
  Helpers to interact with Xarango
  """

  defmacro __using__(_options) do
    quote do
      import Cardo.Xarango

      defmodule Collection do
        @moduledoc """
        Module to encapsulate Xarango functions
        """
        use Xarango.Domain.Document
      end

      # Actual API
      # How to do this dinamically?
      def create(data, options \\ []), do: run(:create, [data, options])
      def one(params), do: run(:one, [params])
      def list(params), do: run(:list, [params])
      def replace(document, data), do: run(:replace, [document, data])
      def update(document, data), do: run(:update, [document, data])
      def destroy(document), do: run(:destroy, [document])
      def fetch(document, field), do: run(:fetch, [document, field])

      @doc """
      Run given fun in the `Collection` proxy module from inside a try/rescue block
      """
      def run(fname, args) do
        apply(__MODULE__.Collection, fname, args)
      rescue
        e in [Xarango.Error] -> {:error, e.message}
      end
    end
  end
end
