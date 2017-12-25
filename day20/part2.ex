defmodule Day20 do
  @input "./input.txt"

  def main do
    particles =
      @input
      |> File.stream!
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_line/1)

    1..1000
    |> Enum.reduce(particles, fn _, particles -> update(particles) end)
    |> Enum.count
    |> IO.inspect
  end

  defp update(particles) do
    particles
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.filter(fn {_, items} -> Enum.count(items) == 1 end)
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.map(&move/1)
  end

  defp move({{p1, p2, p3}, {v1, v2, v3}, {a1, a2, a3} = a}) do
    {
      {p1 + v1 + a1, p2 + v2 + a2, p3 + v3 + a3},
      {v1 + a1, v2 + a2, v3 + a3},
      a
    }
  end

  defp parse_line(line) do
    line
    |> String.replace(~r/>,|[pva=<>]/, "")
    |> String.split(" ")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn pos -> Enum.map(pos, &String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple
  end
end

Day20.main
