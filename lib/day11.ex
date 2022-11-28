defmodule Day11 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      # "5483143223",
      # "2745854711",
      # "5264556173",
      # "6141336146",
      # "6357385478",
      # "4167524645",
      # "2176841721",
      # "6882881134",
      # "4846848554",
      # "5283751526"
      "688",
      "484",
      "528"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day11.txt")
  end

  @spec get_data(boolean()) :: %{{integer(), integer()} => integer()}
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Tools.digit_grid_to_coords_map()
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
