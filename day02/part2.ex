defmodule Day02 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "\t", trim: true))
    |> Stream.map(fn tokens -> Enum.map(tokens, &String.to_integer/1) end)
    |> Stream.map(&Enum.sort_by(&1, fn i -> -i end))
    |> Stream.map(&checksum/1)
    |> Enum.sum
    |> IO.inspect
  end

  def checksum([h | t]) do
    match =
      t
      |> Enum.map(&{div(h, &1), rem(h, &1)})
      |> Enum.find(&match?({_, 0}, &1))

    case match do
      nil -> checksum(t)
      {r, _} -> r
    end
  end
end

Day02.main
