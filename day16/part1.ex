defmodule Day16 do
  @input "./input.txt"
  @items ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
  @size 16

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.split(",")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(@items, &execute/2)
    |> Enum.join
    |> IO.inspect
  end

  defp execute(["s", n], items) do
    count =
      n
      |> String.to_integer
      |> rem(@size)

    {a, b} = Enum.split(items, @size - count)

    b ++ a
  end

  defp execute(["x", i, j], items) do
    i = String.to_integer(i)
    j = String.to_integer(j)

    a = Enum.fetch!(items, i)
    b = Enum.fetch!(items, j)

    items
    |> List.replace_at(i, b)
    |> List.replace_at(j, a)
  end

  defp execute(["p", a, b], items) do
    i = Enum.find_index(items, &(&1 == a))
    j = Enum.find_index(items, &(&1 == b))

    items
    |> List.replace_at(i, b)
    |> List.replace_at(j, a)
  end

  defp parse_line(line) do
    {h, t} = String.split_at(line, 1)

    [h | String.split(t, "/")]
  end
end

Day16.main
