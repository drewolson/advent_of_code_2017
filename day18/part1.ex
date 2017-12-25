defmodule Day18 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_line/1)
    |> Stream.with_index
    |> Enum.reduce(%{}, fn {l, i}, m -> Map.put(m, i, l) end)
    |> execute(%{}, nil, 0)
    |> IO.inspect
  end

  defp execute(lines, registers, last_sound, line) do
    case lines[line] do
      ["snd", reg] ->
        val = Map.get(registers, reg, 0)
        execute(lines, registers, val, line + 1)
      ["set", dest, source] ->
        registers = Map.put(registers, dest, get_value(source, registers))
        execute(lines, registers, last_sound, line + 1)
      ["add", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, val + get_value(source, registers))
        execute(lines, registers, last_sound, line + 1)
      ["mul", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, val * get_value(source, registers))
        execute(lines, registers, last_sound, line + 1)
      ["mod", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, rem(val, get_value(source, registers)))
        execute(lines, registers, last_sound, line + 1)
      ["rcv", reg] ->
        if Map.get(registers, reg, 0) == 0 do
          execute(lines, registers, last_sound, line + 1)
        else
          last_sound
        end
      ["jgz", reg, num] ->
        case Map.get(registers, reg, 0) do
          i when i > 0 ->
            execute(lines, registers, last_sound, line + get_value(num, registers))
          _ ->
            execute(lines, registers, last_sound, line + 1)
        end
    end
  end

  defp get_value(token, _) when is_integer(token), do: token

  defp get_value(token, registers), do: Map.get(registers, token, 0)

  defp parse_line([h | rest]) do
    [h | Enum.map(rest, &maybe_int/1)]
  end

  defp maybe_int(t) do
    with {i, _} <- Integer.parse(t) do
      i
    else
      _ ->
        t
    end
  end
end

Day18.main
