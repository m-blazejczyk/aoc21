defmodule Day05 do
@spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "0,9 -> 5,9",
      "8,0 -> 0,8",
      "9,4 -> 3,4",
      "2,2 -> 2,1",
      "7,0 -> 7,4",
      "6,4 -> 2,0",
      "0,9 -> 2,9",
      "3,4 -> 1,4",
      "0,0 -> 8,8",
      "5,5 -> 8,2"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day05.txt")
  end

  @spec get_data(boolean()) :: [{{integer(), integer()}, {integer(), integer()}}]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.map(&process_row/1)
  end

  @spec process_row(String.t()) :: {{integer(), integer()}, {integer(), integer()}}
  defp process_row(row) do
    row
    |> String.replace(" -> ", ",")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    |> Enum.reduce(%{}, &part1_reducer/2)
    |> Map.values()
    |> Enum.count(fn c -> c > 1 end)
  end

  # The accumulator is a map from coordinates {x, y} to the integer value
  # representing how many times the point at these coords was crossed by a vent
  @spec part1_reducer({{integer(), integer()}, {integer(), integer()}}, map()) :: map()
  defp part1_reducer({{x1, y}, {x2, y}}, acc) do
    x1..x2
    |> Enum.reduce(acc, fn x, acc -> acc |> Map.update({x, y}, 1, fn val -> val + 1 end) end)
  end
  defp part1_reducer({{x, y1}, {x, y2}}, acc) do
    y1..y2
    |> Enum.reduce(acc, fn y, acc -> acc |> Map.update({x, y}, 1, fn val -> val + 1 end) end)
  end
  defp part1_reducer(_, acc) do
    acc
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    |> Enum.reduce(%{}, &part2_reducer/2)
    # |> visualize_grid()
    |> Map.values()
    |> Enum.count(fn c -> c > 1 end)
  end

  defp visualize_grid(coords) do
    IO.inspect(coords |> map_size(), label: "Coords found")

    for y <- 0..9 do
      IO.puts 0..9
      |> Enum.reduce([], fn x, acc -> [coords |> Map.get({x, y}, '.') |> convert() | acc] end)
      |> Enum.reverse()
    end

    coords
  end

  defp convert(1), do: '1'
  defp convert(2), do: '2'
  defp convert(3), do: '3'
  defp convert(a), do: a

  # This reducer is almost identical to the part1 one but it also handles diagonals
  @spec part2_reducer({{integer(), integer()}, {integer(), integer()}}, map()) :: map()
  defp part2_reducer({{x1, y1}, {x2, y2}} = line, acc) do
    if x1 != x2 && y1 != y2 && abs(y2 - y1) == abs(x2 - x1) do
      walk_diagonal({x1, y1}, {x2, y2}, {Tools.sign(x2 - x1), Tools.sign(y2 - y1)}, acc)
    else
      part1_reducer(line, acc)
    end
  end

  # A recursive implementation to handle diagonals
  @spec walk_diagonal(
    {integer(), integer()}, {integer(), integer()}, {integer(), integer()}, map())
    :: map()
  defp walk_diagonal({cur_x, cur_y}, {last_x, last_y} = last, {dx, dy} = delta, acc) do
    if (cur_x != last_x) && (cur_y != last_y) do
      walk_diagonal(
        {cur_x + dx, cur_y + dy}, last, delta,
        acc |> Map.update({cur_x, cur_y}, 1, fn val -> val + 1 end))
    else
      acc |> Map.update({cur_x, cur_y}, 1, fn val -> val + 1 end)
    end
  end
end
