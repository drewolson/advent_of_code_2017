defmodule Day05 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index
    |> Enum.reduce(%{}, fn {n, i}, m -> Map.put(m, i, n) end)
    |> process_lines
    |> IO.inspect
  end

  def process_lines(instructions, line \\ 0, steps \\ 0)

  def process_lines(instructions, line, steps) do
    if Map.has_key?(instructions, line) do
      {next, instructions} = Map.get_and_update(instructions, line, &{&1, &1 + 1})
      process_lines(instructions, line + next, steps + 1)
    else
      steps
    end
  end
end

Day05.main
