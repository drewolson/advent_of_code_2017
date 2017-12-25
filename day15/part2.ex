defmodule Day15 do
  use Bitwise

  def main do
    gen_a = make_generator(591, 16807, 4)
    gen_b = make_generator(393, 48271, 8)

    gen_a
    |> Stream.zip(gen_b)
    |> Stream.take(5_000_000)
    |> Stream.filter(fn {a, b} -> (a &&& 0xFFFF) == (b &&& 0xFFFF) end)
    |> Enum.count
    |> IO.inspect
  end

  defp make_generator(start, factor, divisor) do
    start
    |> Stream.iterate(&rem(&1 * factor, 2147483647))
    |> Stream.drop(1)
    |> Stream.filter(&(rem(&1, divisor) == 0))
  end
end

Day15.main
