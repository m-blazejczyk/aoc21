defmodule Day07 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    ["16,1,2,0,4,2,7,1,2,14"]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day07.txt")
  end

  @spec get_data(boolean()) :: [integer()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> hd()  # The data is in a single line (the frst row)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    # We start by going over the data and figuring out:
    # - The smallest and largest crab positions
    # - A map between crab positions and how many crabs can be found in each
    data = get_data(test_data)

    {min_pos, max_pos, pos_map} = data
    |> Enum.reduce({hd(data), hd(data), %{}}, &init_stage1/2)

    # Second step of the initialization: calculate the fuel cost for the position
    # corresponding to the leftmost crab
    fuel_at_left = pos_map
    |> Enum.reduce(0, fn {pos, count}, acc -> acc + (pos - min_pos) * count end)

    crab_count = length(data)
    crabs_to_the_right = crab_count - (pos_map |> Map.fetch!(min_pos))

    part1_reducer_partial = Tools.partial_2args(&part1_reducer/4, [pos_map, crab_count])

    # Summary of the algorithm: at each position, we keep track of how many crabs
    # are located to the RIGHT of it. We know what the required fuel is at the LEFTMOST
    # position. As we move through the positions towards the right, at each position,
    # every crab to the right of it contributes one unit of fuel LESS than before
    # (because we are now closer to this crab) while each crab to the left of it contributes
    # one fuel MORE (because we are getting farther away from it).
    {fuel, _crabs_to_the_right} = (min_pos + 1)..max_pos
    |> Enum.reduce({[fuel_at_left], crabs_to_the_right}, part1_reducer_partial)

    # IO.inspect(fuel |> Enum.reverse(), charlists: :as_lists)
    fuel
    |> Enum.reverse()
    |> Enum.min()
  end

  @spec init_stage1(integer(), {integer(), integer(), %{integer() => integer()}})
    :: {integer(), integer(), %{integer() => integer()}}
  defp init_stage1(pos, {cur_min, cur_max, pos_map}) do
    {
      # Smallest position in the dataset
      min(cur_min, pos),
      # Largest position in the dataset
      max(cur_max, pos),
      # A map from crabs’ positions to how many crabs there are at a position
      pos_map |> Map.update(pos, 1, fn val -> val + 1 end)
    }
  end

  defp part1_reducer(pos_map, crab_count, pos, {[prev_fuel | _rest] = fuel_list, crabs_to_the_right}) do
    fuel = prev_fuel - crabs_to_the_right + (crab_count - crabs_to_the_right)
    crab_count_here = pos_map |> Map.get(pos, nil)
    if crab_count_here == nil do
      # No crab at this position
      {[fuel | fuel_list], crabs_to_the_right}
    else
      # One or more crab at this position
      {[fuel | fuel_list], crabs_to_the_right - crab_count_here}
    end
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
