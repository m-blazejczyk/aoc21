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
    d = get_data(test_data)
    |> Enum.map(fn row -> String.to_charlist(row) end)

    generator_rating = part2_step(d, [], &which_to_leave_generator/1)
    |> String.to_integer(2)
    scrubber_rating = part2_step(d, [], &which_to_leave_scrubber/1)
    |> String.to_integer(2)

    generator_rating * scrubber_rating
  end

  defp which_to_leave_generator(more_ones), do: if more_ones, do: ?1, else: ?0
  defp which_to_leave_scrubber(more_ones), do:  if more_ones, do: ?0, else: ?1

  defp part2_step(d, history, _) when length(d) == 1 do
    [hd(d) | history]
    |> Enum.reverse()
    |> List.to_string()
  end
  defp part2_step(d, history, which_to_leave) do
    # IO.inspect(d)
    threshold = length(d) / 2  # if the length is 7, this will be 3.5
    one_count = d |> Enum.count(fn [first | _] -> first == ?1 end)
    more_ones = one_count >= threshold
    leave = which_to_leave.(more_ones)
    # IO.puts("We leave items with #{List.to_string([leave])} at the beginning\n")
    part2_step(
      d
      |> Enum.filter(fn [first | _] -> first == leave end)
      |> Enum.map(fn [_ | rest] -> rest end),
      [leave | history],
      which_to_leave)
  end
end
