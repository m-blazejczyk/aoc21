defmodule Day12 do
  @type locations_t :: %{String.t() => [String.t()]}

  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day12.txt")
  end

  @spec get_data(boolean()) :: [String.t()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.reduce(%{}, &parse_row/2)
  end

  @spec parse_row(String.t(), locations_t()) :: locations_t()
  defp parse_row(row, locations) do
    [cave1, cave2] = row
    |> String.split("-")

    locations
    |> add_location(cave1, cave2)
    |> add_location(cave2, cave1)
  end

  @spec add_location(locations_t(), String.t(), String.t()) :: locations_t()
  defp add_location(locations, _from_cave, "start"), do: locations
  defp add_location(locations, "end", _to_cave), do: locations
  defp add_location(locations, from_cave, to_cave) do
    locations
    |> Map.update(from_cave, [to_cave], fn destinations -> [to_cave | destinations] end)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    IO.inspect get_data(test_data)
    0
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
