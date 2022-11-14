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

    low_points = coords_map
    |> Enum.reduce([], find_low_points_partial)

    (low_points |> Enum.sum()) + length(low_points)
  end

  @spec find_low_points(map(), {{integer(), integer()}, integer()}, [integer()]) :: [integer()]
  # Skip points at depth 9 - those are certainly not lower than the surrounding area
  defp find_low_points(_coords_map, {_coord, depth}, acc) when depth == 9, do: acc
  defp find_low_points(coords_map, {{row, col}, depth}, acc) do
    # We don't have to worry about the edges of the area (because Map.get() includes a default!)
    if is_low_point(coords_map, row, col, depth) do
      [depth | acc]
    else
      acc
    end
  end

  @spec is_low_point(map(), integer(), integer(), integer()) :: boolean()
  defp is_low_point(coords_map, row, col, depth) do
    Map.get(coords_map, {row - 1, col}, 9) > depth
      && Map.get(coords_map, {row + 1, col}, 9) > depth
      && Map.get(coords_map, {row, col - 1}, 9) > depth
      && Map.get(coords_map, {row, col + 1}, 9) > depth
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    coords_map = get_data(test_data)

    find_basins_partial = Tools.partial_2args(&find_basins/3, [coords_map])

    {_, basin_sizes} = coords_map
    |> Enum.reduce({MapSet.new(), []}, find_basins_partial)

    basin_count = length(basin_sizes)
    basin_sizes
    |> Enum.sort()
    |> Enum.drop(basin_count - 3)
    |> Enum.product()
  end

  @spec find_basins(map(), {{integer(), integer()}, integer()}, {MapSet.t(), [integer()]})
    :: {MapSet.t(), [integer()]}
  defp find_basins(_coords_map, {coord, depth}, {visited, basin_lengths})
    when depth == 9 do
    # If we run into a point at depth 9 - we just add them to 'visited' and move on
    {visited |> MapSet.put(coord), basin_lengths}
  end
  defp find_basins(coords_map, {coord, _depth}, {visited, basin_lengths} = acc) do
    if visited |> MapSet.member?(coord) do
      # If this coordinate has already been visited, we skip it
      acc
    else
      # We've identified the first location of an unvisited basin.
      # We will now recursively explore this basin from this location.
      prev_size = visited |> MapSet.size()
      new_visited = expand_basin(coords_map, coord, visited)
      {new_visited, [(MapSet.size(new_visited) - prev_size) | basin_lengths]}
    end
  end

  @spec expand_basin(map(), {integer(), integer()}, MapSet.t()) :: MapSet.t()
  defp expand_basin(coords_map, {row, col} = coord, visited) do
    if coords_map |> Map.get(coord, 9) != 9
      &&
      not(visited |> MapSet.member?(coord))
      do
      new_visited = visited |> MapSet.put(coord)
      expand_basin_partial = Tools.partial_2args(&expand_basin/3, [coords_map])

      [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
      |> Enum.reduce(new_visited, expand_basin_partial)
    else
      visited
    end
  end
end
