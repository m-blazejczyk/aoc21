defmodule Day13 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "6,10",
      "0,14",
      "9,10",
      "0,3",
      "10,4",
      "4,11",
      "6,0",
      "6,12",
      "4,1",
      "0,13",
      "10,12",
      "3,4",
      "3,0",
      "8,4",
      "1,10",
      "2,14",
      "8,10",
      "9,0",
      "",
      "fold along y=7",
      "fold along x=5"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day13.txt")
  end

  @spec get_data(boolean()) :: {MapSet.t(), [{:fold_x | :fold_y, integer()}]}
  def get_data(test_data) do
    {dots, folds} = get_raw_data(test_data)
    |> Enum.reduce({MapSet.new(), []}, &parse_row/2)
    {dots, folds |> Enum.reverse()}
  end

  @spec parse_row(String.t(), {MapSet.t(), [{:fold_x | :fold_y, integer()}]})
    :: {MapSet.t(), [{:fold_x | :fold_y, integer()}]}
  defp parse_row(row, {dots, folds} = acc) do
    cond do
      row |> String.starts_with?("fold along y=") ->
        fold_coord = row |> String.replace("fold along y=", "") |> String.to_integer()
        {dots, [{:fold_y, fold_coord} | folds]}
      row |> String.starts_with?("fold along x=") ->
        fold_coord = row |> String.replace("fold along x=", "") |> String.to_integer()
        {dots, [{:fold_x, fold_coord} | folds]}
      row |> String.contains?(",") ->
        [x, y] = row |> String.split(",") |> Enum.map(&String.to_integer/1)
        {dots |> MapSet.put({x, y}), folds}
      true ->
        acc
    end
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    {dots, folds} = get_data(test_data)

    folds
    |> hd()
    |> fold(dots)
    |> MapSet.size()
  end

  @spec fold({:fold_x | :fold_y, integer()}, MapSet.t()) :: MapSet.t()
  defp fold({:fold_y, fold_coord}, dots) do
    # This folds the dots along Y coordinate of 'fold_coord'
    # After the transformation, the Y coordinates decrease towards the folding line
    folded = dots
    |> Enum.reduce(MapSet.new(), fn {x, y}, set -> set |> MapSet.put({x, abs(fold_coord - y)}) end)

    # What is the largest Y coordinate after the fold?
    {_x, max_coord} = folded
    |> Enum.max_by(fn {_x, y} -> y end)

    # Now we scale the coordinates so that they start from zero again
    folded
    |> Enum.reduce(MapSet.new(), fn {x, y}, set -> set |> MapSet.put({x, max_coord - y}) end)
  end
  defp fold({:fold_x, fold_coord}, dots) do
    folded = dots
    |> Enum.reduce(MapSet.new(), fn {x, y}, set -> set |> MapSet.put({abs(fold_coord - x), y}) end)

    {max_coord, _y} = folded
    |> Enum.max_by(fn {x, _y} -> x end)

    folded
    |> Enum.reduce(MapSet.new(), fn {x, y}, set -> set |> MapSet.put({max_coord - x, y}) end)
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    {dots, folds} = get_data(test_data)

    final_coords = folds
    |> Enum.reduce(dots, &fold/2)

    {max_x, max_y} = final_coords
    |> find_maxes()

    # The puzzle output are the letters that are represented by the dots on the paper;
    # we will print out the contents of the paper
    lines = final_coords
    |> Enum.reduce(%{}, &reduce_for_print/2)

    0..max_y
    |> Enum.map(fn y -> row_for_print(lines |> Map.get(y, MapSet.new()), max_x) end)
    |> Enum.each(&IO.puts/1)

    0
  end

  @spec find_maxes(MapSet.t()) :: {integer(), integer()}
  defp find_maxes(coords) do
    {_x, max_y} = coords
    |> Enum.max_by(fn {_x, y} -> y end)

    {max_x, _y} = coords
    |> Enum.max_by(fn {x, _y} -> x end)

    {max_x, max_y}
  end

  defp reduce_for_print({x, y}, rows_map) do
    {_, new_rows_map} = rows_map
    |> Map.get_and_update(y, fn
      nil -> {nil, MapSet.new([x])}
      coords_at_y -> {coords_at_y, coords_at_y |> MapSet.put(x)}
    end)
    new_rows_map
  end

  @spec row_for_print(MapSet.t(), integer()) :: String.t()
  defp row_for_print(dot_coords, max_x) do
    0..max_x
    |> Enum.map(fn x -> if dot_coords |> MapSet.member?(x), do: "#", else: "." end)
    |> Enum.join("")
  end
end
