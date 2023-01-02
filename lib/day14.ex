defmodule Day14 do
  @type rules_t :: %{{String.t(), String.t()} => String.t()}
  @type part2_map_t :: %{{String.t(), String.t(), :start | :end | :middle} => non_neg_integer()}

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

  @spec get_data(boolean()) :: {[String.t()], rules_t()}
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

    # This is the naive implementation that simply builds the final string.
    # It won't work for larger values of 'n' because the strin won't fit into memory.
    final_sequence = build_sequence(10, template, rules)

    {{_, min}, {_, max}} = final_sequence
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_v, count} -> count end)

    max - min
  end

  @spec build_sequence(non_neg_integer(), [String.t()], rules_t())
    :: [String.t()]
  defp build_sequence(0, template, _), do: template
  defp build_sequence(n, template, rules) do
    to_weave = template |> apply_rules(rules, [])
    new_template = Tools.interweave(template, to_weave)
    build_sequence(n - 1, new_template, rules)
  end

  @spec apply_rules(list(), rules_t(), list()) :: list()
  defp apply_rules([_], _rules, out), do: out |> Enum.reverse()
  defp apply_rules([template1 | [template2 | template_rest]], rules, out) do
    m = rules |> Map.get({template1, template2})
    apply_rules([template2 | template_rest], rules, [m | out])
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    {[template_first | [template_second | _] = template_rest], rules} = get_data(test_data)
    initial_pair_counts = template_rest |> to_pairs(%{{template_first, template_second, :start} => 1})

    final_counts = iterate(40, rules, initial_pair_counts)

    {start_elem, end_elem, mid_elem_counts} = final_counts
    |> Enum.reduce({nil, nil, %{}}, &summarize/2)

    elem_counts = mid_elem_counts
    |> Enum.map(fn {elem, cnt} -> {elem, div(cnt, 2)} end)  # All elements in the middle of the sequence are counted twice
    |> Enum.into(%{})  # Insert back into a map
    |> Map.update(start_elem, 1, &(&1 + 1))  # The start element of the sequence is only counted once
    |> Map.update(end_elem, 1, &(&1 + 1))    # …and so is the last one

    {{_, min}, {_, max}} = elem_counts
    |> Enum.min_max_by(fn {_elem, cnt} -> cnt end)

    max - min
  end

  @spec to_pairs([String.t()], part2_map_t()) :: part2_map_t()
  defp to_pairs([before_last | [last | []]], pair_counts) do
    pair_counts |> Map.put({before_last, last, :end}, 1)
  end
  defp to_pairs([first | [second | _] = rest], pair_counts) do
    to_pairs(rest, pair_counts |> Map.update({first, second, :middle}, 1, &(&1 + 1)))
  end

  @spec iterate(non_neg_integer(), rules_t(), part2_map_t()) :: part2_map_t()
  defp iterate(0, _rules, pair_counts), do: pair_counts
  defp iterate(n, rules, pair_counts) do
    grow_pair_partial = Tools.partial_2args(&grow_pair/3, [rules])
    iterate(n - 1, rules, pair_counts |> Enum.reduce(%{}, grow_pair_partial))
  end

  defp grow_pair(rules, {{first, second, :start}, cnt}, pair_counts) do
    to_insert = rules |> Map.get({first, second})
    pair_counts
    |> Map.put({first, to_insert, :start}, 1)
    |> Map.update({to_insert, second, :middle}, cnt, &(&1 + cnt))
  end
  defp grow_pair(rules, {{first, second, :middle}, cnt}, pair_counts) do
    to_insert = rules |> Map.get({first, second})
    pair_counts
    |> Map.update({first, to_insert, :middle}, cnt, &(&1 + cnt))
    |> Map.update({to_insert, second, :middle}, cnt, &(&1 + cnt))
  end
  defp grow_pair(rules, {{first, second, :end}, cnt}, pair_counts) do
    to_insert = rules |> Map.get({first, second})
    pair_counts
    |> Map.update({first, to_insert, :middle}, cnt, &(&1 + cnt))
    |> Map.put({to_insert, second, :end}, 1)
  end

  defp summarize({{first, second, :start}, cnt}, {_, end_elem, elem_counts}) do
    {first, end_elem, elem_counts |> Map.update(second, cnt, &(&1 + cnt))}
  end
  defp summarize({{first, second, :end}, cnt}, {start_elem, _, elem_counts}) do
    {start_elem, second, elem_counts |> Map.update(first, cnt, &(&1 + cnt))}
  end
  defp summarize({{first, second, :middle}, cnt}, {start_elem, end_elem, elem_counts}) do
    {start_elem, end_elem, elem_counts |> Map.update(first, cnt, &(&1 + cnt)) |> Map.update(second, cnt, &(&1 + cnt))}
  end
end
