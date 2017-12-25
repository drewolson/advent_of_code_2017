defmodule Day03 do
  @goal 312051

  def main do
    0
    |> Stream.iterate(&(&1 + 2))
    |> Stream.flat_map(&build_instructions/1)
    |> Stream.scan({0, 0}, &move/2)
    |> Enum.reduce_while(%{}, &calculate_node/2)
    |> IO.inspect
  end

  defp calculate_node(loc, nodes) when loc == {0, 0} do
    {:cont, Map.put(nodes, loc, 1)}
  end

  defp calculate_node(loc, nodes) do
    value =
      loc
      |> neighbors
      |> Enum.map(&Map.get(nodes, &1, 0))
      |> Enum.sum

    if value > @goal do
      {:halt, value}
    else
      {:cont, Map.put(nodes, loc, value)}
    end
  end

  defp neighbors({x, y}) do
    [
      {x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1},
      {x, y - 1}, {x, y + 1},
      {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}
    ]
  end

  defp build_instructions(side_size) when side_size == 0, do: [{0, 0}]

  defp build_instructions(side_size) do
    [{1, 0}] ++
      Enum.map(2..side_size, fn _ -> {0, 1} end) ++
      Enum.map(1..side_size, fn _ -> {-1, 0} end) ++
      Enum.map(1..side_size, fn _ -> {0, -1} end) ++
      Enum.map(1..side_size, fn _ -> {1, 0} end)
  end

  defp move({x, y}, {x1, y1}) do
    {x + x1, y + y1}
  end
end

Day03.main
