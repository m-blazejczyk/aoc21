defmodule Day04 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1",
      "",
      "22 13 17 11  0",
      " 8  2 23  4 24",
      "21  9 14 16  7",
      " 6 10  3 18  5",
      " 1 12 20 15 19",
      "",
      " 3 15  0  2 22",
      " 9 18 13 17  5",
      "19  8  7 25 23",
      "20 11 10 24  4",
      "14 21 16 12  6",
      "",
      "14 21 17 24  4",
      "10 16 15  9 19",
      "18  8 23 26 20",
      "22 11 13  6  5",
      " 2  0 12  3  7"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day04.txt")
  end

  @spec get_data(boolean()) :: {[integer()], [[integer()]]}
  def get_data(test_data) do
    [first_row | remaining_rows] = get_raw_data(test_data)
    |> Enum.filter(fn line -> String.length(line) > 0 end)

    random_numbers = first_row
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    boards = remaining_rows
    |> Enum.map(&String.split/1)
    |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)
    |> Enum.chunk_every(5)
    |> Enum.filter(fn l -> length(l) == 5 end)

    {random_numbers, boards}
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    IO.inspect(get_data(test_data))
    0
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    # get_data(test_data)
    0
  end
end
