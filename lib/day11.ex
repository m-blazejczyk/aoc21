defmodule Day11 do
  @type pos_t :: {integer(), integer()}
  @type grid_t :: %{pos_t() => integer()}

  @neighbors [{0, 0}, {-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "5483143223",
      "2745854711",
      "5264556173",
      "6141336146",
      "6357385478",
      "4167524645",
      "2176841721",
      "6882881134",
      "4846848554",
      "5283751526"
      # "11111",
      # "19991",
      # "19191",
      # "19991",
      # "11111"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day11.txt")
  end

  @spec get_data(boolean()) :: grid_t()
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Tools.digit_grid_to_coords_map()
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    grid = get_data(test_data)

    {_grid, flash_count} = 1..100
    |> Enum.reduce({grid, 0}, &step/2)

    flash_count
  end

  @spec step(integer(), {grid_t(), integer()}) :: {grid_t(), integer()}
  defp step(_, {grid, flash_count}) do
    # First, increase the energy of each octopus by 1
    new_grid_list = grid
    |> Enum.map(fn {pos, energy} -> {pos, energy + 1} end)

    # Then, flash!
    new_grid_list
    |> flash_grid_helper({new_grid_list |> Enum.into(%{}), flash_count})
  end

  @spec flash_grid_helper([{pos_t(), integer()}], {grid_t(), integer()}) :: {grid_t(), integer()}
  defp flash_grid_helper(will_flash, acc) do
    # Here we find out which positions contain "saturated" octopuses (energy > 9)
    # and we pass a list of their positions to flash_grid()
    will_flash
    |> Enum.filter(fn {_, energy} -> energy > 9 end)
    |> Enum.map(fn {pos, _} -> pos end)
    |> flash_grid(acc)
  end

  @spec flash_grid([pos_t()], {grid_t(), integer()}) :: {grid_t(), integer()}
  defp flash_grid([], acc), do: acc
  defp flash_grid(flashing, acc) do
    new_acc = {new_grid, _new_flash_count} = flashing
    |> Enum.reduce(acc, &flash_octopus/2)

    # We keep going for as long as there are "saturated" octopuses
    new_grid
    |> Map.to_list()
    |> flash_grid_helper(new_acc)
  end

  @spec flash_octopus(pos_t(), {grid_t(), integer()}) :: {grid_t(), integer()}
  defp flash_octopus(pos, {old_grid, old_flash_count}) do
    flash_around_partial = Tools.partial_2args(&flash_around/3, [pos])

    new_grid = @neighbors
    |> Enum.reduce(old_grid, flash_around_partial)

    {new_grid, old_flash_count + 1}
  end

  @spec flash_around(pos_t(), pos_t(), grid_t()) :: grid_t()
  # At delta={0, 0} is the octopus that is flashing; set its energy to 0
  defp flash_around(pos, {0, 0}, grid), do: grid |> Map.put(pos, 0)
  # Here we have to be mindful of locations that are off-grid
  defp flash_around({pos_x, pos_y}, {dx, dy}, grid) do
    new_pos = {pos_x + dx, pos_y + dy}
    if grid |> Map.has_key?(new_pos) do
      grid |> Map.update!(new_pos, &react_to_flash/1)
    else
      grid
    end
  end

  @spec react_to_flash(integer()) :: integer()
  # An octopus that has flashed in this step is not impacted by surrounding flashes
  defp react_to_flash(0), do: 0
  # …but any other one will increase its energy
  defp react_to_flash(energy), do: energy + 1

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
