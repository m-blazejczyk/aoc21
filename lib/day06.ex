defmodule Day06 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    ["3,4,3,1,2"]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day06.txt")
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
    |> solution(80)
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    |> solution(256)
  end

  @spec solution([integer()], integer()) :: integer()
  defp solution(data, days) do
    freqs = data
    |> Enum.frequencies()

    # Build the initial map; it will track the number of fish of each generation
    # (i.e. having the internal clock set to the given value)
    # e.g. initial_clocks[0] is how many fish have their internal clock set to 0
    #        and will spawn the next day
    #      initial_clocks[4] is how many fish have their internal clock set to 4
    #      and so on
    initial_clocks = 0..8
    |> Enum.map(fn idx -> freqs |> Map.get(idx, 0) end)

    1..days
    |> Enum.reduce(initial_clocks, &next_day/2)
    |> Enum.sum()
  end

  @spec next_day(any(), [integer()]) :: [integer()]
  defp next_day(_, [c0, c1, c2, c3, c4, c5, c6, c7, c8]) do
    [c1, c2, c3, c4, c5, c6, c7+c0, c8, c0]
    # 0   1   2   3   4   5   6      7   8
  end
end
