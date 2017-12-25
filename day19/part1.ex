defmodule Day19 do
  @input "./input.txt"

  def main do
    grid =
      @input
      |> File.stream!
      |> Enum.map(&String.trim(&1, "\n"))
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index
      |> Enum.reduce(%{}, &build_grid/2)

    pos =
      0
      |> Stream.iterate(&(&1 + 1))
      |> Stream.map(&{&1, 0})
      |> Enum.find(&Map.has_key?(grid, &1))

    pos
    |> walk_grid(:s, grid[pos], grid, [])
    |> IO.inspect
  end

  defp walk_grid(_, _, nil, _, letters) do
    letters
    |> Enum.reverse
    |> Enum.join
  end

  defp walk_grid(pos, dir, cell, grid, letters) do
    letters = if cell =~ ~r/[A-Z]/, do: [cell | letters], else: letters
    {pos, dir} = next_state(pos, dir, grid)

    walk_grid(pos, dir, grid[pos], grid, letters)
  end

  defp next_state({x, y} = pos, dir, grid) do
    next_pos = case dir do
      :n -> {x, y - 1}
      :s -> {x, y + 1}
      :e -> {x + 1, y}
      :w -> {x - 1, y}
    end

    next_dir = case grid[next_pos] do
      "+" ->
        neighbor =
          next_pos
          |> neighbors(grid)
          |> Enum.reject(&(&1 == pos))
          |> hd

        {new_x, new_y} = next_pos

        case neighbor do
          {a, _} when a > new_x -> :e
          {a, _} when a < new_x -> :w
          {_, b} when b > new_y -> :s
          {_, b} when b < new_y -> :n
        end
      _ -> dir
    end

    {next_pos, next_dir}
  end

  defp neighbors({x, y}, grid) do
    [
      {x + 1, y}, {x - 1, y},
      {x, y + 1}, {x, y - 1}
    ]
    |> Enum.filter(&Map.has_key?(grid, &1))
  end

  defp build_grid({line, j}, grid) do
    line
    |> Enum.with_index
    |> Enum.reduce(grid, fn
      {" ", _}, grid -> grid
      {e, i}, grid -> Map.put(grid, {i, j}, e)
    end)
  end
end

Day19.main
