defmodule Day02 do
  @spec get_data :: [{String.t(), integer()}]
  def get_data() do
    Tools.read_file("day02.txt")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [instruction, value_str] -> {instruction, String.to_integer(value_str)} end)
  end

  @spec part1 :: number()
  def part1() do
    get_data()
    |> Enum.reduce({0, 0}, &process_row_for_part1/2)
    |> Kernel.then(fn {depth, distance} -> depth * distance end)
  end

  @spec process_row_for_part1({String.t(), integer()}, {integer(), integer()}) :: {integer(), integer()}
  defp process_row_for_part1({"forward", value}, {depth, distance}), do: {depth, distance + value}
  defp process_row_for_part1({"up", value},      {depth, distance}), do: {depth - value, distance}
  defp process_row_for_part1({"down", value},    {depth, distance}), do: {depth + value, distance}
end
