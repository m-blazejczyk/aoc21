defmodule Day07 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    ["16,1,2,0,4,2,7,1,2,14"]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day07.txt")
  end

  @spec get_data(boolean()) :: [integer()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> hd()  # The data is in a single line (the frst row)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
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
