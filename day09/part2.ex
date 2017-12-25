defmodule Day09 do
  @input "./input.txt"

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.graphemes
    |> unescape
    |> count_garbage
    |> IO.inspect
  end

  def count_garbage(chars, acc \\ [])

  def count_garbage([], acc), do: Enum.count(acc)

  def count_garbage(["<" | t], acc) do
    {garbage, rest} = Enum.split_while(t, &(&1 != ">"))

    rest
    |> tl
    |> count_garbage(garbage ++ acc)
  end

  def count_garbage([_ | t], acc) do
    count_garbage(t, acc)
  end

  def unescape(chars, acc \\ [])
  def unescape([], acc), do: Enum.reverse(acc)
  def unescape(["!", _ | t], acc), do: unescape(t, acc)
  def unescape([h | t], acc), do: unescape(t, [h | acc])
end

Day09.main
