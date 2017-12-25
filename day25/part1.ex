defmodule Day25 do
  @machine %{
    "a" => %{
      0 => {1, 1, "b"},
      1 => {0, -1, "c"}
    },
    "b" => %{
      0 => {1, -1, "a"},
      1 => {1, 1, "c"}
    },
    "c" => %{
      0 => {1, 1, "a"},
      1 => {0, -1, "d"}
    },
    "d" => %{
      0 => {1, -1, "e"},
      1 => {1, -1, "c"}
    },
    "e" => %{
      0 => {1, 1, "f"},
      1 => {1, 1, "a"}
    },
    "f" => %{
      0 => {1, 1, "a"},
      1 => {1, 1, "e"}
    },
  }
  @steps 12261543

  def main do
    %{}
    |> process("a", 0, 0)
    |> checksum
    |> IO.inspect
  end

  defp checksum(tape) do
    tape
    |> Map.values
    |> Enum.filter(&(&1 == 1))
    |> Enum.count
  end

  defp process(tape, _, _, steps) when steps == @steps, do: tape

  defp process(tape, state, index, steps) do
    value = Map.get(tape, index, 0)
    {new_value, dir, new_state} = @machine[state][value]

    tape
    |> Map.put(index, new_value)
    |> process(new_state, index + dir, steps + 1)
  end
end

Day25.main
