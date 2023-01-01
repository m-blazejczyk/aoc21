defmodule Day14 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "NNCB",
      # "",  # Empty lines are skipped by Tools.read_file()
      "CH -> B",
      "HH -> N",
      "CB -> H",
      "NH -> C",
      "HB -> C",
      "HC -> B",
      "HN -> C",
      "NN -> C",
      "BH -> H",
      "NC -> B",
      "NB -> B",
      "BN -> B",
      "BB -> N",
      "BC -> B",
      "CC -> N",
      "CN -> C"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day14.txt")
  end

  @spec get_data(boolean()) :: {[String.t()], %{{String.t(), String.t()} => String.t()}}
  def get_data(test_data) do
    [template | rules_str] = get_raw_data(test_data)

    rules = rules_str
    |> Enum.map(fn rule ->
      [from, to] = rule |> String.split(" -> ")
      {from |> String.graphemes() |> List.to_tuple(), to}
    end)
    |> Enum.into(%{})

    {template |> String.graphemes(), rules}
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    {template, rules} = get_data(test_data)

    final_sequence = build_sequence(10, template, rules)

    {{_, min}, {_, max}} = final_sequence
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_v, count} -> count end)

    max - min
  end

  @spec build_sequence(non_neg_integer(), [String.t()], %{{String.t(), String.t()} => String.t()})
    :: [String.t()]
  defp build_sequence(0, template, _), do: template
  defp build_sequence(n, template, rules) do
    to_weave = template |> apply_rules(rules, [])
    new_template = Tools.interweave(template, to_weave)
    build_sequence(n - 1, new_template, rules)
  end

  @spec apply_rules(list(), %{{String.t(), String.t()} => String.t()}, list()) :: list()
  defp apply_rules([_], _rules, out), do: out |> Enum.reverse()
  defp apply_rules([template1 | [template2 | template_rest]], rules, out) do
    m = rules |> Map.get({template1, template2})
    apply_rules([template2 | template_rest], rules, [m | out])
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
