defmodule Day03 do
  @goal 312051

  def main do
    {x, y} =
      0
      |> Stream.iterate(&(&1 + 2))
      |> Stream.flat_map(&build_instructions/1)
      |> Stream.scan({0, 0}, &move/2)
      |> Enum.fetch!(@goal - 1)

    IO.inspect(abs(x) + abs(y))
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
