defmodule Day06 do
  @input "./input.txt"

  def main do
    @input
    |> File.read!
    |> String.trim
    |> String.split(~r/\s+/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {e, i}, m -> Map.put(m, i, e) end)
    |> cycle
    |> IO.inspect
  end

  defp cycle(state, visited \\ %{}, step \\ 0)

  defp cycle(state, visited, step) do
    if Map.has_key?(visited, state) do
      step - visited[state]
    else
      state
      |> redistribute
      |> cycle(Map.put(visited, state, step), step + 1)
    end
  end

  defp redistribute(state) do
    {i, n} = Enum.max_by(state, fn {i, n} -> {n, -i} end)

    state
    |> Map.put(i, 0)
    |> redistribute(n, i + 1)
  end

  defp redistribute(state, 0, _), do: state

  defp redistribute(state, n, i) when i == map_size(state) do
    redistribute(state, n, 0)
  end

  defp redistribute(state, n, i) do
    state
    |> Map.update(i, 0, &(&1 + 1))
    |> redistribute(n - 1, i + 1)
  end
end

Day06.main
