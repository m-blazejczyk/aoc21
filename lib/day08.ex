defmodule Day08 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      # "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf",
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
    |> Enum.map(&prepare_input/1)
    |> Enum.map(&decode_digits/1)
    |> Enum.sum()
  end

  @spec prepare_input([String.t()]) :: {[MapSet.t()], [MapSet.t()]}
  defp prepare_input(raw) do
    {digits, [_pipe | output]} = raw
    |> Enum.map(fn item ->
      item
      |> String.to_charlist()
      |> MapSet.new()
    end)
    |> Enum.split(10)

    {digits, output}
  end

  @spec decode_digits({[MapSet.t()], [MapSet.t()]}) :: integer()
  defp decode_digits({digits, output}) do
    # These digits have a unique number of segments
    d1 = digits |> Enum.find(fn set -> MapSet.size(set) == 2 end)
    d4 = digits |> Enum.find(fn set -> MapSet.size(set) == 4 end)
    d7 = digits |> Enum.find(fn set -> MapSet.size(set) == 3 end)
    d8 = digits |> Enum.find(fn set -> MapSet.size(set) == 7 end)

    # Lists of sets with 5 (2, 3 or 5) and 6 (6, 9 or 0) segments, respectively
    seg5 = digits |> Enum.filter(fn set -> MapSet.size(set) == 5 end)
    seg6 = digits |> Enum.filter(fn set -> MapSet.size(set) == 6 end)

    # 3 is the only one with 5 segments that include all the segments from a 1
    d3 = seg5 |> Enum.find(fn set -> MapSet.intersection(set, d1) == d1 end)
    seg5 = seg5 |> List.delete(d3)

    # 9 is the only one with 6 segments that include all the segments from a 4
    d9 = seg6 |> Enum.find(fn set -> MapSet.intersection(set, d4) == d4 end)
    seg6 = seg6 |> List.delete(d9)

    # Between a 5 and a 2, a 5 contains the top-left segment
    top_left = MapSet.difference(d9, d3)
    d5 = seg5 |> Enum.find(fn set -> MapSet.intersection(set, top_left) == top_left end)
    seg5 = seg5 |> List.delete(d5)

    # And 2 is the remaining 5-segment digit
    d2 = hd(seg5)

    # Between a 6 and a 0, a zero has all the segments from a 1
    d0 = seg6 |> Enum.find(fn set -> MapSet.intersection(set, d1) == d1 end)
    seg6 = seg6 |> List.delete(d0)

    # …and only the 6 remains
    d6 = hd(seg6)

    all_digits = [{0, d0}, {1, d1}, {2, d2}, {3, d3}, {4, d4}, {5, d5}, {6, d6}, {7, d7}, {8, d8}, {9, d9}]

    {res, _} = output
    |> Enum.map(fn out_digit ->
      all_digits |> Enum.find_value(fn {res, set} -> if set == out_digit, do: res, else: nil end)
    end)
    |> Enum.reverse()
    |> Enum.reduce({0, 1}, fn digit, {sum, multiplier} -> {sum + (digit * multiplier), multiplier * 10} end)

    res
  end
end
