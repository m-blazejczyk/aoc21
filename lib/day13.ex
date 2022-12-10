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

  @spec get_data(boolean()) :: [String.t()]
  def get_data(test_data) do
    get_raw_data(test_data)
    |> Enum.reduce({%{}, nil, nil}, &parse_row/2)
  end

  @spec parse_row(String.t(), {%{{integer(), integer()} => boolean()}, integer(), integer()})
    :: {%{{integer(), integer()} => boolean()}, integer(), integer()}
  defp parse_row(row, {dots, fold_y, fold_x} = acc) do
    cond do
      row |> String.starts_with?("fold along y=") ->
        {dots, row |> String.replace("fold along y=", "") |> String.to_integer(), fold_x}
      row |> String.starts_with?("fold along x=") ->
        {dots, fold_y, row |> String.replace("fold along x=", "") |> String.to_integer()}
      row |> String.contains?(",") ->
        [x, y] = row |> String.split(",")
        {dots |> Map.put({x, y}, true), fold_y, fold_x}
      true ->
        acc
    end
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    IO.inspect get_data(test_data)
    0
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    get_data(test_data)
    0
  end
end
