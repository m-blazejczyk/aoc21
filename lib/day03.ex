defmodule Day03 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]
    # [7, 5, 8, 7, 5]
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
    d = get_data(test_data)

    threshold = div(length(d), 2)
    row_len = String.length(hd(d))

    gamma_rate_clist = d
    |> Enum.reduce(List.duplicate(0, row_len), &process_row/2)
    |> Enum.map(fn v -> if v > threshold, do: ?1, else: ?0 end)
    gamma_rate = gamma_rate_clist
    |> List.to_string()
    |> String.to_integer(2)

    epsilon_rate = gamma_rate_clist
    |> Enum.map(fn c -> if c == ?1, do: ?0, else: ?1 end)
    |> List.to_string()
    |> String.to_integer(2)

    gamma_rate * epsilon_rate
  end

  @spec process_row(String.t(), [non_neg_integer()]) :: [non_neg_integer()]
  def process_row(row, acc) do
    row
    |> String.to_charlist
    |> Enum.map(fn c -> c - ?0 end)
    |> Tools.map2(acc, fn v1, v2 -> v1+v2 end)
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
