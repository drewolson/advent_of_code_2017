defmodule Day24 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "/"))
    |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> valid_bridges
    |> Enum.group_by(&Enum.count/1)
    |> Enum.max_by(&elem(&1, 0))
    |> elem(1)
    |> Stream.map(&strength/1)
    |> Enum.max
    |> IO.inspect
  end

  defp valid_bridges(links) do
    valid_bridges(links, 0, [])
  end

  defp valid_bridges(links, match, bridge) do
    next = Enum.filter(links, fn [a, b] -> a == match || b == match end)

    if Enum.count(next) == 0 do
      [bridge]
    else
      Enum.flat_map(next, fn [a, b] = link ->
        rest = Enum.reject(links, &(&1 == link))
        new_match = if a == match, do: b, else: a

        valid_bridges(rest, new_match, [link | bridge])
      end)
    end
  end

  defp strength(bridge) do
    bridge
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum
  end
end

Day24.main
