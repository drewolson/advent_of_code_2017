defmodule Day04 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.filter(&valid?/1)
    |> Enum.count
    |> IO.inspect
  end

  def valid?(line, set \\ MapSet.new())

  def valid?([], _), do: true

  def valid?([h | t], set) do
    if Enum.member?(set, h) do
      false
    else
      valid?(t, MapSet.put(set, h))
    end
  end
end

Day04.main
