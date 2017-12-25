defmodule Day09 do
  @input "./input.txt"

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.graphemes
    |> unescape
    |> drop_garbage
    |> count_groups
    |> IO.inspect
  end

  def count_groups(chars, level \\ 1, total \\ 0)

  def count_groups([], _, total), do: total

  def count_groups(["{" | t], level, total) do
    count_groups(t, level + 1, total + level)
  end

  def count_groups(["," | t], level, total) do
    count_groups(t, level, total)
  end

  def count_groups(["}" | t], level, total) do
    count_groups(t, level - 1, total)
  end

  def drop_garbage(chars, acc \\ [])

  def drop_garbage([], acc), do: Enum.reverse(acc)

  def drop_garbage(["<" | t], acc) do
    t
    |> Enum.drop_while(&(&1 != ">"))
    |> tl
    |> drop_garbage(acc)
  end

  def drop_garbage([h | t], acc) do
    drop_garbage(t, [h | acc])
  end

  def unescape(chars, acc \\ [])
  def unescape([], acc), do: Enum.reverse(acc)
  def unescape(["!", _ | t], acc), do: unescape(t, acc)
  def unescape([h | t], acc), do: unescape(t, [h | acc])
end

Day09.main
