defmodule Day09 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "2199943210",
      "3987894921",
      "9856789892",
      "8767896789",
      "9899965678"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day09.txt")
  end

  @spec get_data(boolean()) :: map()
  def get_data(test_data) do
    get_raw_data(test_data)
    |> rows_to_coords(0, Map.new())
    |> Enum.reduce(Map.new(), &cols_to_coords/2)
  end

  @spec rows_to_coords([String.t()], integer(), map()) :: map()
  defp rows_to_coords([], _index, acc) do
    acc
  end
  defp rows_to_coords([first | rest], index, acc) do
    rows_to_coords(rest, index + 1, Map.put(acc, index, first))
  end

  @spec cols_to_coords({integer(), String.t()}, map()) :: map()
  defp cols_to_coords({row_index, row_str}, acc) do
    row_str
    |> String.to_charlist()
    |> Tools.reduce_index(acc, fn val, col_index, acc -> acc |> Map.put({row_index, col_index}, val - 48) end)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    |> map_size()
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
