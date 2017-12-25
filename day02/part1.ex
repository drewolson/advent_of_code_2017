defmodule Day02 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "\t", trim: true))
    |> Stream.map(fn tokens -> Enum.map(tokens, &String.to_integer/1) end)
    |> Stream.map(&checksum/1)
    |> Enum.sum
    |> IO.inspect
  end

  def checksum(line, acc \\ {9999, 0})
  def checksum([], {min, max}), do: max - min
  def checksum([h | t], {min, max}) when h < min and h > max, do: checksum(t, {h, h})
  def checksum([h | t], {min, max}) when h < min, do: checksum(t, {h, max})
  def checksum([h | t], {min, max}) when h > max, do: checksum(t, {min, h})
  def checksum([_ | t], acc), do: checksum(t, acc)
end

Day02.main
