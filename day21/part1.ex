defmodule Day21 do
  @input "./input.txt"
  @start [
    [".", "#", "."],
    [".", ".", "#"],
    ["#", "#", "#"]
  ]

  def main do
    rules =
      @input
      |> File.stream!
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, " => "))
      |> Stream.map(fn rule ->
        rule
        |> Enum.map(&String.split(&1, "/"))
        |> Enum.map(fn lines -> Enum.map(lines, &String.graphemes/1) end)
      end)
      |> Enum.reduce(%{}, fn [k, v], map ->
        k
        |> variants
        |> Enum.reduce(map, &Map.put(&2, &1, v))
      end)

    1..5
    |> Enum.reduce(@start, fn _, grid -> update_grid(grid, rules) end)
    |> Stream.concat
    |> Stream.filter(&(&1 == "#"))
    |> Enum.count
    |> IO.inspect
  end

  defp update_grid(grid, rules) do
    chunk = if grid |> Enum.count |> rem(2) == 0, do: 2, else: 3

    grid
    |> Enum.chunk_every(chunk)
    |> Enum.flat_map(fn rows ->
      rows
      |> Enum.map(&Enum.chunk_every(&1, chunk))
      |> transpose
      |> Enum.map(&Map.get(rules, &1))
      |> transpose
      |> Enum.map(&Enum.concat/1)
    end)
  end

  defp variants(square) do
    transposed = transpose(square)

    [
      square,
      square |> Enum.reverse,
      square |> Enum.map(&Enum.reverse/1),
      square |> Enum.map(&Enum.reverse/1) |> Enum.reverse,
      transposed,
      transposed |> Enum.reverse,
      transposed |> Enum.map(&Enum.reverse/1),
      transposed |> Enum.map(&Enum.reverse/1) |> Enum.reverse,
    ]
  end

  defp transpose(matrix) do
    matrix
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
  end
end

Day21.main
