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
    |> execute(%{"p" => 0, "count" => 0}, %{"p" => 1, "count" => 0}, 0, 0, [], [])
    |> IO.inspect
  end

  defp execute(lines, registers_a, registers_b, line_a, line_b, values_a, values_b) do
    inst_a = lines[line_a]
    inst_b = lines[line_b]

    case {inst_a, inst_b, values_a, values_b} do
      {["rcv" | _], ["rcv" | _], [], []} ->
        registers_b["count"]
      _ ->
        {registers_a, line_a, values_a, values_b} = execute_line(lines, registers_a, line_a, values_a, values_b)
        {registers_b, line_b, values_b, values_a} = execute_line(lines, registers_b, line_b, values_b, values_a)

        execute(lines, registers_a, registers_b, line_a, line_b, values_a, values_b)
    end
  end

  defp execute_line(lines, registers, line, values_in, values_out) do
    case lines[line] do
      ["set", dest, source] ->
        registers = Map.put(registers, dest, get_value(source, registers))
        {registers, line + 1, values_in, values_out}
      ["add", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, val + get_value(source, registers))
        {registers, line + 1, values_in, values_out}
      ["mul", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, val * get_value(source, registers))
        {registers, line + 1, values_in, values_out}
      ["mod", dest, source] ->
        val = Map.get(registers, dest, 0)
        registers = Map.put(registers, dest, rem(val, get_value(source, registers)))
        {registers, line + 1, values_in, values_out}
      ["jgz", reg, num] ->
        case get_value(reg, registers) do
          i when i > 0 ->
            {registers, line + get_value(num, registers), values_in, values_out}
          _ ->
            {registers, line + 1, values_in, values_out}
        end
      ["rcv", reg] ->
        case values_in do
          [h | t] ->
            registers = Map.put(registers, reg, h)
            {registers, line + 1, t, values_out}
          _ ->
            {registers, line, values_in, values_out}
        end
      ["snd", reg] ->
        registers = Map.update(registers, "count", 0, &(&1 + 1))
        val = Map.get(registers, reg, 0)
        {registers, line + 1, values_in, values_out ++ [val]}
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
