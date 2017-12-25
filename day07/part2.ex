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
    |> find_new_weight
    |> IO.inspect
  end

  defp find_new_weight({_, weight, []}), do: {weight, weight}

  defp find_new_weight({_, weight, children}) do
    child_weights = Enum.map(children, &find_new_weight/1)
    error = Enum.find(child_weights, &match?({:error, _}, &1))

    evaluate_node(weight, child_weights, error)
  end

  defp evaluate_node(_, _, {:error, _} = error), do: error

  defp evaluate_node(weight, child_weights, _) do
    groups = Enum.group_by(child_weights, &elem(&1, 0))

    if Enum.count(groups) == 1 do
      total_child_weights = child_weights |> Enum.map(&elem(&1, 0)) |> Enum.sum

      {weight + total_child_weights, weight}
    else
      [{bad_total, bad_weight}, {correct_total, _}] =
        groups
        |> Map.values
        |> Enum.sort_by(&Enum.count/1)
        |> Enum.map(&hd/1)

      {:error, bad_weight + (correct_total - bad_total)}
    end
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
