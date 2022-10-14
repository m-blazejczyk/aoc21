defmodule Day02 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day02.txt")
  end

  @spec get_data(boolean()) :: [{String.t(), integer()}]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [instruction, value_str] -> {instruction, String.to_integer(value_str)} end)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    |> Enum.reduce({0, 0}, &process_row_for_part1/2)
    |> Kernel.then(fn {depth, distance} -> depth * distance end)
  end

  @spec process_row_for_part1({String.t(), integer()}, {integer(), integer()}) :: {integer(), integer()}
  defp process_row_for_part1({"forward", value}, {depth, distance}), do: {depth, distance + value}
  defp process_row_for_part1({"up", value},      {depth, distance}), do: {depth - value, distance}
  defp process_row_for_part1({"down", value},    {depth, distance}), do: {depth + value, distance}

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    |> Enum.reduce({0, 0, 0}, &process_row_for_part2/2)
    |> Kernel.then(fn {depth, distance, _aim} -> depth * distance end)
  end

  @spec process_row_for_part2({String.t(), integer()}, {integer(), integer(), integer()})
    :: {integer(), integer(), integer()}
  defp process_row_for_part2({"forward", value}, {depth, distance, aim}) do
    {depth + aim * value, distance + value, aim}
  end
  defp process_row_for_part2({"up", value}, {depth, distance, aim}) do
    {depth, distance, aim - value}
  end
  defp process_row_for_part2({"down", value}, {depth, distance, aim}) do
    {depth, distance, aim + value}
  end
end
