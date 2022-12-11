defmodule Day13 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "6,10",
      "0,14",
      "9,10",
      "0,3",
      "10,4",
      "4,11",
      "6,0",
      "6,12",
      "4,1",
      "0,13",
      "10,12",
      "3,4",
      "3,0",
      "8,4",
      "1,10",
      "2,14",
      "8,10",
      "9,0",
      "",
      "fold along y=7",
      "fold along x=5"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day13.txt")
  end

  @spec get_data(boolean()) :: {integer(), integer(), [{integer(), integer()}]}
  def get_data(test_data) do
    [fold_x_str|[fold_y_str|[_empty|dots]]] = get_raw_data(test_data)
    |> Enum.reverse()

    {fold_x_str |> String.replace("fold along x=", "") |> String.to_integer(),
      fold_y_str |> String.replace("fold along y=", "") |> String.to_integer(),
      dots |> Enum.map(&parse_position/1)}
  end

  @spec parse_position(String.t()) :: {integer(), integer()}
  defp parse_position(pos_str) do
    [x, y] = pos_str |> String.split(",") |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    {_fold_x, fold_y, dots} = get_data(test_data)

    dots
    |> Enum.reduce(MapSet.new(), fn {x, y}, set -> set |> MapSet.put({x, abs(fold_y - y)}) end)
    |> IO.inspect()
    |> MapSet.size()
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
