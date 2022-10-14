defmodule DayTemplate do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    []
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day03.txt")
  end

  @spec get_data(boolean()) :: [String.t()]
  def get_data(test_data) do
    get_raw_data(test_data)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    0
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
