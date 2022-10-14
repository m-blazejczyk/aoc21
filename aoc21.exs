# How to invoke:
# mix run aoc21.exs 2 test
# or
# mix run aoc21.exs 2

[day | rest] = System.argv()
test_data = length(rest) >= 1 && hd(rest) == "test"
module_name = "Elixir.Day" <> String.pad_leading(day, 2, "0")
module = String.to_existing_atom(module_name)

IO.puts("::: Day #{day} :::")
if test_data do
  IO.puts("... test data ...")
else
  IO.puts("... real data ...")
end

IO.puts("Part 1 result: #{module.part1(test_data)}")
IO.puts("Part 2 result: #{module.part2(test_data)}")
