defmodule Day22 do
  @input "./input.txt"
  @cycles 10_000_000

  def main do
    tokens =
      @input
      |> File.stream!
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)

    bound = tokens |> Enum.count |> div(2)

    tokens
    |> Enum.zip(bound..-bound)
    |> Enum.reduce(%{}, fn {row, y}, map ->
      row
      |> Enum.zip(-bound..bound)
      |> Enum.reduce(map, fn {t, x}, map -> Map.put(map, {x, y}, t) end)
    end)
    |> move({0, 0}, :n, 0, 0)
    |> IO.inspect
  end

  defp move(_, _, _, count, infected) when count == @cycles, do: infected

  defp move(grid, pos, dir, count, infected) do
    node = Map.get(grid, pos, ".")
    new_dir = case node do
      "." -> turn_left(dir)
      "-" -> dir
      "#" -> turn_right(dir)
      "!" -> u_turn(dir)
    end
    new_pos = move(new_dir, pos)

    case node do
      "." ->
        grid
        |> Map.put(pos, "-")
        |> move(new_pos, new_dir, count + 1, infected)
      "-" ->
        grid
        |> Map.put(pos, "#")
        |> move(new_pos, new_dir, count + 1, infected + 1)
      "#" ->
        grid
        |> Map.put(pos, "!")
        |> move(new_pos, new_dir, count + 1, infected)
      "!" ->
        grid
        |> Map.put(pos, ".")
        |> move(new_pos, new_dir, count + 1, infected)
    end
  end

  defp turn_left(:n), do: :w
  defp turn_left(:s), do: :e
  defp turn_left(:e), do: :n
  defp turn_left(:w), do: :s

  defp turn_right(:n), do: :e
  defp turn_right(:s), do: :w
  defp turn_right(:e), do: :s
  defp turn_right(:w), do: :n

  defp u_turn(:n), do: :s
  defp u_turn(:s), do: :n
  defp u_turn(:e), do: :w
  defp u_turn(:w), do: :e

  defp move(:n, {x, y}), do: {x, y + 1}
  defp move(:s, {x, y}), do: {x, y - 1}
  defp move(:e, {x, y}), do: {x + 1, y}
  defp move(:w, {x, y}), do: {x - 1, y}
end

Day22.main
