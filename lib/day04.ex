defmodule Day04 do
  @spec get_raw_data(boolean()) :: [String.t()]
  defp get_raw_data(_test_data = true) do
    [
      "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1",
      "",
      "22 13 17 11  0",
      " 8  2 23  4 24",
      "21  9 14 16  7",
      " 6 10  3 18  5",
      " 1 12 20 15 19",
      "",
      " 3 15  0  2 22",
      " 9 18 13 17  5",
      "19  8  7 25 23",
      "20 11 10 24  4",
      "14 21 16 12  6",
      "",
      "14 21 17 24  4",
      "10 16 15  9 19",
      "18  8 23 26 20",
      "22 11 13  6  5",
      " 2  0 12  3  7"
    ]
  end
  defp get_raw_data(_test_data = false) do
    Tools.read_file("day04.txt")
  end

  @spec get_data(boolean()) :: {[integer()], [[integer()]]}
  def get_data(test_data) do
    [first_row | remaining_rows] = get_raw_data(test_data)
    |> Enum.filter(fn line -> String.length(line) > 0 end)

    random_numbers = first_row
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    boards = remaining_rows
    |> Enum.map(&String.split/1)
    |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)
    |> Enum.chunk_every(5)
    |> Enum.filter(fn l -> length(l) == 5 end)

    {random_numbers, boards}
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    # On initialization, we create two maps like this:
    # value -> [{board, row, col}]
    #   - we'll use this to look up coordinates of values on boards
    # id -> sum of all values in the board
    #   - we'll use this to calculate the final value to be returned
    #     (the sum of values that were not marked yet on the winning board)

    # There is also a third map that we will use to create the solution:
    # {board, row_or_col, :row / :col} -> count
    #   - it will track count of guessed values per row / column;
    #     if this count reaches 5 for any row or column, we have the winner!

    {random_numbers, boards} = get_data(test_data)

    {initial_coords_tracker, initial_sums_tracker} = boards
    |> Tools.reduce_index(
      {%{}, %{}},
      fn board, board_id, acc -> board |> Tools.reduce_index(acc,
        fn row, row_id, acc -> row |> Tools.reduce_index(acc,
          fn value, col_id, acc -> build_part1_trackers(board_id, row_id, col_id, value, acc) end) end) end
    )

    {_, _, _, final_score} = random_numbers
    |> Enum.reduce({initial_coords_tracker, initial_sums_tracker, %{}, nil}, &part1_reducer/2)

    final_score
  end

  @spec build_part1_trackers(integer(), integer(), integer(), integer(), {map(), map()})
    :: {map(), map()}
  defp build_part1_trackers(board_id, row_id, col_id, value, {coords_tracker, sums_tracker}) do
    {_, new_coords_tracker} = coords_tracker
    |> Map.get_and_update(value, fn
      nil -> {nil, [{board_id, row_id, col_id}]}
      list -> {list, [{board_id, row_id, col_id} | list]}
    end)

    {_, new_sums_tracker} = sums_tracker
    |> Map.get_and_update(board_id, fn
      nil -> {nil, value}
      old_sum -> {old_sum, old_sum + value}
    end)

    {new_coords_tracker, new_sums_tracker}
  end

  @spec part1_reducer(integer(), {map(), map(), map(), integer()})
    :: {map(), map(), map(), integer()}
  defp part1_reducer(guess, {coords_tracker, sums_tracker, rowcol_tracker, nil}) do

    {final_coords_tracker, final_sums_tracker, final_rowcol_tracker, _, final_score} = coords_tracker
    |> Map.get(guess)  # This returns a list of coordinates
    |> Enum.reduce({coords_tracker, sums_tracker, rowcol_tracker, guess, nil}, &handle_guess_at_coords/2)

    {final_coords_tracker, final_sums_tracker, final_rowcol_tracker, final_score}
  end
  # This function clause will be invoked whenever the clause above has found
  # a full row or column and the last element of the accumulator tuple has been set.
  defp part1_reducer(_guess, acc) do
    acc
  end

  @spec handle_guess_at_coords(
    {integer(), integer(), integer()},
    {map(), map(), map(), integer(), nil | integer()})
    :: {map(), map(), map(), integer(), nil | integer()}
  defp handle_guess_at_coords(
    {board_id, row_id, col_id},
    {coords_tracker, sums_tracker, rowcol_tracker, guess, nil}) do

    # First, update the sums for the board; remove (subtract) the current guess
    # so that the sum reflects all the values that haven't been guessed yet
    new_sums_tracker = sums_tracker
    |> Map.update!(board_id, fn old_sum -> old_sum - guess end)

    # Then, mark the fact that there was one (or one more) guessed value in this row
    {new_row_count, new_rowcol_tracker} = rowcol_tracker
    |> Map.get_and_update({board_id, row_id, :row}, fn
      nil -> {1, 1}
      old_count -> {old_count + 1, old_count + 1}
    end)

    if new_row_count == 5 do
      # If the entire row has been guessed, add the board id in the last position
      # of the accumulator tuple to stop further calculations
      {coords_tracker,
       new_sums_tracker,
       new_rowcol_tracker,
       guess,
       (new_sums_tracker |> Map.get(board_id)) * guess}
    else
      # Finally, mark the fact that there was one (or one more) guessed value in this column
      {new_col_count, newer_rowcol_tracker} = new_rowcol_tracker
      |> Map.get_and_update({board_id, col_id, :col}, fn
        nil -> {1, 1}
        old_count -> {old_count + 1, old_count + 1}
      end)

      if new_col_count == 5 do
        {coords_tracker,
         new_sums_tracker,
         new_rowcol_tracker,
         guess,
         (new_sums_tracker |> Map.get(board_id)) * guess}
       else
        {coords_tracker, new_sums_tracker, newer_rowcol_tracker, guess, nil}
      end
    end
  end
  # This function clause will be invoked whenever the clause above has found
  # a full row or column.
  defp handle_guess_at_coords(_coords, acc) do
    acc
  end

  @spec part2(boolean()) :: number()
  def part2(_test_data) do
    # get_data(test_data)
    0
  end
end
