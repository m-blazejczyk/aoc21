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
    data = get_data(test_data)
    |> Enum.filter(&is_good_for_part1/1)

    IO.inspect(data)

    0
  end

  @spec is_good_for_part1({{integer(), integer()}, {integer(), integer()}}) :: boolean()
  defp is_good_for_part1({{_x1, y}, {_x2, y}}), do: true
  defp is_good_for_part1({{x, _y1}, {x, _y2}}), do: true
  defp is_good_for_part1({{_x1, _y1}, {_x2, _y2}}), do: false

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
