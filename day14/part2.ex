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
    |> Stream.map(&to_row/1)
    |> Enum.reduce({0, MapSet.new()}, &to_grid/2)
    |> elem(1)
    |> find_groups(0)
    |> IO.inspect
  end

  defp find_groups(grid, groups) do
    if Enum.count(grid) == 0 do
      groups
    else
      grid
      |> Enum.take(1)
      |> remove_cells(grid)
      |> find_groups(groups + 1)
    end
  end

  defp remove_cells([], grid), do: grid

  defp remove_cells(cells, grid) do
    grid = Enum.reduce(cells, grid, &MapSet.delete(&2, &1))

    cells
    |> Enum.flat_map(&neighbors/1)
    |> Enum.uniq
    |> Enum.filter(&Enum.member?(grid, &1))
    |> remove_cells(grid)
  end

  defp neighbors({x, y}) do
    [
      {x + 1, y}, {x - 1, y},
      {x, y + 1}, {x, y - 1}
    ]
  end

  defp to_grid(row, {num, set}) do
    set =
      row
      |> Enum.with_index
      |> Enum.reduce(set, fn {c, i}, set ->
        if c == "1" do
          MapSet.put(set, {i, num})
        else
          set
        end
      end)

    {num + 1, set}
  end

  defp to_row(hash) do
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
