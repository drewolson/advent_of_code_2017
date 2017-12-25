defmodule KnotHash do
  @length 256
  @cycles 64

  def for(input) do
    lengths =
      input
      |> to_charlist
      |> Enum.concat([17, 31, 73, 47, 23])

    elements = Enum.reduce(0..255, %{}, &Map.put(&2, &1, &1))

    elements
    |> hashing(lengths, 0, 0, 0)
    |> Stream.chunk_every(16)
    |> Stream.map(fn block ->
      use Bitwise

      Enum.reduce(block, &Bitwise.bxor(&2, &1))
    end)
    |> Stream.map(&Integer.to_string(&1, 16))
    |> Stream.map(&String.pad_leading(&1, 2, "0"))
    |> Enum.join
    |> String.downcase
  end

  defp hashing(elements, _, _, _, i) when i == @cycles do
    elements
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end

  defp hashing(elements, lengths, pos, skip, i) do
    {elements, pos, skip} = hash(elements, lengths, pos, skip)

    hashing(elements, lengths, pos, skip, i + 1)
  end

  defp hash(elements, [], pos, skip) do
    {elements, pos, skip}
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

defmodule Day14 do
  @input "wenycdww"

  def main do
    0..127
    |> Stream.map(&Integer.to_string/1)
    |> Stream.map(&(@input <> "-" <> &1))
    |> Stream.map(&KnotHash.for/1)
    |> Stream.map(&to_grid/1)
    |> Stream.map(&Enum.filter(&1, fn c -> c == "1" end))
    |> Stream.map(&Enum.count/1)
    |> Enum.sum
    |> IO.inspect
  end

  def to_grid(hash) do
    hash
    |> String.graphemes
    |> Stream.map(&String.to_integer(&1, 16))
    |> Stream.map(&Integer.to_string(&1, 2))
    |> Stream.map(&String.pad_leading(&1, 4, "0"))
    |> Enum.join
    |> String.graphemes
  end
end

Day14.main
