defmodule Day01 do
  @spec get_data :: [integer()]
  def get_data() do
    Tools.read_file("day01.txt")
    |> Enum.map(&String.to_integer/1)
  end

  @spec how_many_increases(list()) :: non_neg_integer()
  def how_many_increases(l) do
    List.zip([l, Enum.drop(l, 1)]) |> Enum.count(fn {prev, next} -> next > prev end)
  end

  @spec part1(boolean()) :: non_neg_integer()
  def part1(_test_data) do
    get_data()
    |> how_many_increases()
  end

  @spec part2(boolean()) :: non_neg_integer()
  def part2(_test_data) do
    l = get_data()
    Enum.zip_with([l, Enum.drop(l, 1), Enum.drop(l, 2)], fn [a, b, c] -> a + b + c end)
    |> how_many_increases()
  end
end
