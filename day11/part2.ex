defmodule Day11 do
  @input "./input.txt"

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.split(",")
    |> Enum.reduce({{0,0,0}, 0}, &move/2)
    |> elem(1)
    |> IO.inspect
  end

  defp move(dir, {pos, max}), do: {new_coord(dir, pos), max(max, distance(pos))}

  defp new_coord("n", {x, y, z}), do: {x + 1, y, z - 1}
  defp new_coord("s", {x, y, z}), do: {x - 1, y, z + 1}
  defp new_coord("ne", {x, y, z}), do: {x + 1, y - 1, z}
  defp new_coord("nw", {x, y, z}), do: {x, y + 1, z - 1}
  defp new_coord("se", {x, y, z}), do: {x, y - 1, z + 1}
  defp new_coord("sw", {x, y, z}), do: {x - 1, y + 1, z}

  defp distance(pos) do
    pos
    |> Tuple.to_list
    |> Enum.map(&abs/1)
    |> Enum.max
  end
end

Day11.main
