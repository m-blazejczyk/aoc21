defmodule Day08 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
      "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
      "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
      "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
      "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
      "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
      "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
      "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
      "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
      "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day08.txt")
  end

  @spec get_data(boolean()) :: [[String.t()]]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.map(&String.split/1)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    get_data(test_data)
    # Take into account only the strings (values) that come AFTER the '|' character
    |> Enum.map(fn items ->
      items |> Enum.drop(1 + (items |> Enum.find_index(fn x -> x == "|" end)))
    end)
    # Filter by string length and add up the counts
    |> Enum.reduce(0, fn items, res ->
      res + (items |> Enum.count(fn item -> String.length(item) in [2, 3, 4, 7] end))
    end)
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
