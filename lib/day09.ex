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
    |> Tools.reduce_index(Map.new(), fn row_str, row_index, acc ->
      row_str
      |> String.to_charlist()
      |> Tools.reduce_index(acc, fn val, col_index, acc ->
        acc |> Map.put({row_index, col_index}, val - 48)
      end)
    end)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    coords_map = get_data(test_data)

    find_low_points_partial = Tools.partial_2args(&find_low_points/3, [coords_map])

    low_points = get_data(test_data)
    |> Enum.reduce([], find_low_points_partial)

    (low_points |> Enum.sum()) + length(low_points)
  end

  @spec find_low_points(map(), {{integer(), integer()}, integer()}, [integer()]) :: [integer()]
  # Skip points at depth 9 - those are certainly not lower than the surrounding area
  defp find_low_points(_coords_map, {_coord, depth}, acc) when depth == 9, do: acc
  defp find_low_points(coords_map, {{row, col}, depth}, acc) do
    # We don't have to worry about the edges of the area (because Map.get() includes a default!)
    if Map.get(coords_map, {row - 1, col}, 9) > depth
      && Map.get(coords_map, {row + 1, col}, 9) > depth
      && Map.get(coords_map, {row, col - 1}, 9) > depth
      && Map.get(coords_map, {row, col + 1}, 9) > depth do
        [depth | acc]
      else
        acc
      end
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
