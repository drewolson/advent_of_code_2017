defmodule Day10 do
  @input "./input.txt"
  @length 256

  def main do
    lengths =
      @input
      |> File.read!
      |> String.trim
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    elements = Enum.reduce(0..255, %{}, &Map.put(&2, &1, &1))

    elements
    |> hash(lengths, 0, 0)
    |> IO.inspect
  end

  defp hash(elements, [], _, _) do
    elements[0] * elements[1]
  end

  defp hash(elements, [length | rest], pos, skip) do
    indicies =
      0..length - 1
      |> Stream.map(&(&1 + pos))
      |> Stream.map(&rem(&1, @length))

    indicies
    |> Enum.map(&Map.get(elements, &1))
    |> Enum.reverse
    |> Enum.zip(indicies)
    |> Enum.reduce(elements, fn {e, i}, m -> Map.put(m, i, e) end)
    |> hash(rest, rem(pos + length + skip, @length), skip + 1)
  end
end

Day10.main
