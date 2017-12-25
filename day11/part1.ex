defmodule Day11 do
  @input "./input.txt"

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.split(",")
    |> Enum.reduce({0,0,0}, &move/2)
    |> Tuple.to_list
    |> Enum.map(&abs/1)
    |> Enum.max
    |> IO.inspect
  end

  defp move("n", {x, y, z}), do: {x + 1, y, z - 1}
  defp move("s", {x, y, z}), do: {x - 1, y, z + 1}
  defp move("ne", {x, y, z}), do: {x + 1, y - 1, z}
  defp move("nw", {x, y, z}), do: {x, y + 1, z - 1}
  defp move("se", {x, y, z}), do: {x, y - 1, z + 1}
  defp move("sw", {x, y, z}), do: {x - 1, y + 1, z}
end

Day11.main
