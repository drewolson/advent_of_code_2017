defmodule Day07 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.replace(&1, ~r/[(),]/, ""))
    |> Stream.map(&String.split(&1, " "))
    |> Enum.map(&parse_line/1)
    |> build_tree
    |> elem(0)
    |> IO.inspect
  end

  defp build_tree(nodes, rest \\ [], result \\ %{})

  defp build_tree([], [], result) do
    result |> Map.values |> hd
  end

  defp build_tree([], rest, result) do
    build_tree(rest, [], result)
  end

  defp build_tree([{name, weight, children} = h | t], rest, result) do
    if Enum.all?(children, &Map.has_key?(result, &1)) do
      new_children = Enum.map(children, &Map.get(result, &1))

      new_result =
        result
        |> Map.put(name, {name, weight, new_children})
        |> Map.drop(children)

      build_tree(t, rest, new_result)
    else
      build_tree(t, [h | rest], result)
    end
  end

  defp parse_line([name, weight]) do
    {name, String.to_integer(weight), []}
  end

  defp parse_line([name, weight, "->" | children]) do
    {name, String.to_integer(weight), children}
  end
end

Day07.main
