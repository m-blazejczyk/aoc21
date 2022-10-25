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

  @spec solution(boolean()) :: [number()]
  def solution(test_data) do
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

    {coords_map, initial_sums_tracker} = boards
    |> Tools.reduce_index(
      {%{}, %{}},
      fn board, board_id, acc -> board |> Tools.reduce_index(acc,
        fn row, row_id, acc -> row |> Tools.reduce_index(acc,
          fn value, col_id, acc -> build_trackers(board_id, row_id, col_id, value, acc) end) end) end
    )

    reducer = Tools.partial_2args(&reducer/3, [coords_map])

    # The accumulator consists of:
    # - The sums tracker (the sum of unguessed values per board)
    # - The "rowcol" tracker for keeping info on how many correct guesses we have,
    #   per row or column
    # - The output tuple which consists of two data structures:
    #   - A list of the final scores for all boards, ordered by when they were completed
    #     (it's just a list of integers)
    #   - A map of board ids that have been completed (for faster lookups)
    {_, _, {final_scores, _}} = random_numbers
    |> Enum.reduce({initial_sums_tracker, %{}, {[], %MapSet{}}}, reducer)

    final_scores
  end

  @spec build_trackers(integer(), integer(), integer(), integer(), {map(), map()})
    :: {map(), map()}
  defp build_trackers(board_id, row_id, col_id, value, {coords_map, sums_tracker}) do
    {_, new_coords_map} = coords_map
    |> Map.get_and_update(value, fn
      nil -> {nil, [{board_id, row_id, col_id}]}
      list -> {list, [{board_id, row_id, col_id} | list]}
    end)

    {_, new_sums_tracker} = sums_tracker
    |> Map.get_and_update(board_id, fn
      nil -> {nil, value}
      old_sum -> {old_sum, old_sum + value}
    end)

    {new_coords_map, new_sums_tracker}
  end

  @spec reducer(map(), integer(), {map(), map(), {[integer()], MapSet.t()}})
    :: {map(), map(), {[integer()], MapSet.t()}}
  defp reducer(
    coords_map,
    guess,
    {_, _, {_, completed_boards}} = acc) do

    handle_guess = Tools.partial_2args(&handle_guess_at_coords/3, [guess])

    coords_map
    # This returns a list of coordinates where this guess can be found
    |> Map.get(guess)
    # This filters out boards that have already been completed
    |> Enum.filter(fn {board_id, _, _} -> ! (completed_boards |> MapSet.member?(board_id)) end)
    |> Enum.reduce(acc, handle_guess)
  end

  @spec handle_guess_at_coords(
    integer(),
    {integer(), integer(), integer()},
    {map(), map(), {[integer()], MapSet.t()}})
    :: {map(), map(), {[integer()], MapSet.t()}}
  defp handle_guess_at_coords(
    guess,
    {board_id, row_id, col_id},
    {sums_tracker, rowcol_tracker, {final_scores, completed_boards}}) do

    # First, update the sums for the board; remove (subtract) the current guess
    # so that the sum reflects all the values that haven't been guessed yet
    new_sums_tracker = sums_tracker
    |> Map.update!(board_id, fn old_sum -> old_sum - guess end)

    # Then, mark the fact that there was one (or one more) guessed value
    # in this row and column
    {new_row_count, new_rowcol_tracker} = rowcol_tracker
    |> Map.get_and_update({board_id, row_id, :row}, fn
      nil -> {1, 1}
      old_count -> {old_count + 1, old_count + 1}
    end)
    {new_col_count, newer_rowcol_tracker} = new_rowcol_tracker
    |> Map.get_and_update({board_id, col_id, :col}, fn
      nil -> {1, 1}
      old_count -> {old_count + 1, old_count + 1}
    end)

    if new_row_count == 5 || new_col_count == 5 do
      # If an entire row or column has been guessed, mark the board as completed etc.
      {new_sums_tracker,
       new_rowcol_tracker,
       mark_board_completed(
        board_id,
        (new_sums_tracker |> Map.get(board_id)) * guess,
        {final_scores, completed_boards})}
    else
      {new_sums_tracker, newer_rowcol_tracker, {final_scores, completed_boards}}
    end
  end

  @spec mark_board_completed(integer(), integer(), {[integer()], MapSet.t()})
    :: {[integer()], MapSet.t()}
  defp mark_board_completed(board_id, score, {final_scores, completed_boards}) do
    {
      [score | final_scores],
      completed_boards |> MapSet.put(board_id)
    }
  end

  @spec part1(boolean()) :: number()
  def part1(test_data) do
    test_data
    |> solution()
    |> Enum.reverse()
    |> hd()
  end

  @spec part2(boolean()) :: number()
  def part2(test_data) do
    test_data
    |> solution()
    |> hd()
  end
end
