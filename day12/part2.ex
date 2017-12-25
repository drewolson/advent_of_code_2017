defmodule Day12 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.replace(&1, ",", ""))
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {node, children}, map -> Map.put(map, node, children) end)
    |> groups
    |> Enum.count
    |> IO.inspect
  end

  defp groups(map) do
    groups(map, Map.keys(map), [])
  end

  defp groups(_, [], groups), do: groups

  defp groups(map, [node | rest], groups) do
    group = group_for(map, node)

    nodes =
      rest
      |> MapSet.new
      |> MapSet.difference(group)
      |> Enum.to_list

    groups(map, nodes, [group | groups])
  end

  defp group_for(map, node) do
    group_for(map, [node], MapSet.new())
  end

  defp group_for(_, [], visited), do: visited

  defp group_for(map, nodes, visited) do
    visited =
      nodes
      |> MapSet.new
      |> MapSet.union(visited)

    nodes =
      nodes
      |> Enum.flat_map(&Map.get(map, &1))
      |> MapSet.new
      |> MapSet.difference(visited)
      |> Enum.to_list

    group_for(map, nodes, visited)
  end

  defp parse_line([node, "<->" | children]) do
    {node, children}
  end
end

Day12.main
