defmodule Day12 do
  # The boolean means "is this cave small?"
  @type cave_t :: {String.t(), boolean()}
  @type locations_t :: %{String.t() => [cave_t()]}

  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day12.txt")
  end

  @spec get_data(boolean()) :: [String.t()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.reduce(%{}, &parse_row/2)
  end

  @spec parse_row(String.t(), locations_t()) :: locations_t()
  defp parse_row(row, locations) do
    [cave1, cave2] = row
    |> String.split("-")

    locations
    |> add_location(cave1, cave2)
    |> add_location(cave2, cave1)
  end

  @spec add_location(locations_t(), String.t(), String.t()) :: locations_t()
  defp add_location(locations, _from_cave, "start"), do: locations
  defp add_location(locations, "end", _to_cave), do: locations
  defp add_location(locations, from_cave, to_cave) do
    cave = create_cave(to_cave)
    locations
    |> Map.update(from_cave, [cave], fn destinations -> [cave | destinations] end)
  end

  @spec create_cave(String.t()) :: cave_t()
  defp create_cave(cave_name) do
    {cave_name, String.upcase(cave_name) != cave_name}
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    {_, all_paths} = get_data(test_data)
    |> walk_caves_part1({"start", true}, {[], []})

    # IO.inspect(all_paths |> Enum.map(&Enum.reverse/1))

    length(all_paths)
  end

  defp walk_caves_part1(_all_caves, {cave = "end", _is_small}, {path, all_paths}) do
    path_to_add = [cave | path]
    {path, [path_to_add | all_paths]}
  end
  defp walk_caves_part1(all_caves, {cave, is_small}, {path, all_paths} = acc) do
    # Check if we already visited this cave
    if is_small && path |> Enum.member?(cave) do
      acc
    else
      walk_caves_partial = Tools.partial_2args(&walk_caves_part1/3, [all_caves])

      {_new_path, new_all_paths} = all_caves
      |> Map.get(cave)
      |> Enum.reduce({[cave | path], all_paths}, walk_caves_partial)

      # ALWAYS return the old path. Otherwise, the new path returned above may contain
      # a lot of additional caves that have been explored but rejected as invalid paths.
      # Returning the old path here "resets" the path as far as the caller is concerned.
      {path, new_all_paths}
    end
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    {_, _, all_paths} = get_data(test_data)
    |> walk_caves_part2({"start", true}, {[], %{}, []})

    # IO.inspect(all_paths |> Enum.map(&Enum.reverse/1))

    length(all_paths)
  end

  defp walk_caves_part2(_all_caves, {cave = "end", _is_small}, {path, cave_tracker, all_paths}) do
    path_to_add = [cave | path]
    {path, cave_tracker, [path_to_add | all_paths]}
  end
  defp walk_caves_part2(all_caves, {cave, is_small}, {path, cave_tracker, all_paths} = acc) do
    # Check if we already visited this cave; in part 2, this is a bit more involved
    # because ONE of the small caves can be visited twice
    if is_small && not can_be_entered(cave, cave_tracker) do
      acc
    else
      walk_caves_partial = Tools.partial_2args(&walk_caves_part2/3, [all_caves])

      {_new_path, _new_cave_tracker, new_all_paths} = all_caves
      |> Map.get(cave)
      |> Enum.reduce(
        {[cave | path],
          (if is_small, do: cave_tracker |> Map.update(cave, 1, fn v -> v + 1 end), else: cave_tracker),
          all_paths},
        walk_caves_partial)

      # ALWAYS return the old path (and cave set). Otherwise, the new path returned above
      # may contain a lot of additional caves that have been explored but rejected as invalid
      # paths. Returning the old path here "resets" the path as far as the caller is concerned.
      {path, cave_tracker, new_all_paths}
    end
  end

  @spec can_be_entered(String.t(), %{String.t() => integer()}) :: boolean()
  defp can_be_entered(cave, cave_tracker) do
    # Here, we are checking how many times each cave WOULD be visited IF we visited this one
    vals = cave_tracker
    |> Map.update(cave, 1, fn v -> v + 1 end)
    |> Map.values()

    (vals |> Enum.all?(fn v -> v <= 1 end)) or (vals |> Enum.count(fn v -> v == 2 end) == 1)
  end
end
