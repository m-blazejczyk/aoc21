defmodule Day10 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "[({(<(())[]>[[{[]{<()<>>",  # incomplete
      "[(()[<>])]({[<{<<[]>>(",    # incomplete
      "{([(<{}[<>[]}>{[]{[(<()>",  # invalid
      "(((({<>}<{<{<>}{[]{[]{}",   # incomplete
      "[[<[([]))<([[{}[[()]]]",    # invalid
      "[{[{({}]{}}([{[{{{}}([]",   # invalid
      "{<[[]]>}<{[{[{[]{()[[[]",   # incomplete
      "[<(<(<(<{}))><([]([]()",    # invalid
      "<{([([[(<>()){}]>(<<{{",    # invalid
      "<{([{{}}[<[[[<>{}]]]>[]]"   # incomplete
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day10.txt")
  end

  @spec get_data(boolean()) :: [charlist()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.map(&String.to_charlist/1)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    |> Enum.map(fn line -> line |> Enum.reduce([], &handle_char/2) end)
    |> Enum.filter(&Kernel.is_integer/1)
    |> Enum.sum()
  end

  @spec handle_char(char(), charlist() | integer()) :: charlist() | integer()
  # If the accumulator is an integer, it means that an ilegal character was found;
  # we're breaking out of the loop
  defp handle_char(_, result) when is_integer(result), do: result
  # We found an opening bracket; add it on top of the stack (the accumulator)
  defp handle_char(c, stack) when c == ?(, do: [c | stack]
  defp handle_char(c, stack) when c == ?[, do: [c | stack]
  defp handle_char(c, stack) when c == ?<, do: [c | stack]
  defp handle_char(c, stack) when c == ?{, do: [c | stack]
  # We found a closing bracket that corresponds to the opening character
  # on top of the stack: "pop" it
  defp handle_char(c, [prev | rest]) when c == ?) and prev == ?(, do: rest
  defp handle_char(c, [prev | rest]) when c == ?] and prev == ?[, do: rest
  defp handle_char(c, [prev | rest]) when c == ?> and prev == ?<, do: rest
  defp handle_char(c, [prev | rest]) when c == ?} and prev == ?{, do: rest
  # Invalid closing bracket
  defp handle_char(c, _) when c == ?), do: 3
  defp handle_char(c, _) when c == ?], do: 57
  defp handle_char(c, _) when c == ?>, do: 25137
  defp handle_char(c, _) when c == ?}, do: 1197

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
