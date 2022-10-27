defmodule Tools do
  @spec read_file(String.t()) :: [String.t()]
  def read_file(name) do
    data = ("data/" <> name)
    |> File.read!()
    |> String.split("\n", trim: true)

    IO.inspect(length(data), label: "Lines loaded from file")

    data
  end

  @spec sign(number()) :: -1 | 0 | 1
  def sign(x) when x > 0, do: 1
  def sign(x) when x == 0, do: 0
  def sign(x) when x < 0, do: -1

  @spec map2([any()], [any()], function()) :: [any()]
  def map2(list1, list2, fun) do
    reduce2(list1, list2, [], fun) |> Enum.reverse()
  end

  @spec reduce2([any()], [any()], [any()], function()) :: [any()]
  defp reduce2([], [], acc, _fun) do
    acc
  end
  defp reduce2([elem1 | rest1], [elem2 | rest2], acc, fun) do
    reduce2(rest1, rest2, [fun.(elem1, elem2) | acc], fun)
  end

  @spec reduce_index([any()], any(), function()) :: any()
  def reduce_index(l, acc, fun) do
    reduce_index_impl(l, 0, acc, fun)
  end

  @spec reduce_index_impl([any()], integer(), any(), function()) :: any()
  defp reduce_index_impl([], _index, acc, _fun) do
    acc
  end
  defp reduce_index_impl([head | rest], index, acc, fun) do
    reduce_index_impl(rest, index + 1, fun.(head, index, acc), fun)
  end

  @spec partial_2args(fun(), [any()]) :: fun()
  def partial_2args(f, initial_args) do
    fn arg1, arg2 -> apply(f, initial_args ++ [arg1, arg2]) end
  end
end
