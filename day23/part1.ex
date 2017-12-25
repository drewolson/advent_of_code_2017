defmodule Day23 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Stream.with_index
    |> Stream.map(fn {instruction, line} -> {line, instruction} end)
    |> Enum.into(%{})
    |> execute(%{}, 0)
    |> IO.inspect
  end

  defp execute(instructions, registers, line) when line >= map_size(instructions) do
    registers["count"]
  end

  defp execute(instructions, registers, line) do
    {registers, line} = execute_line(instructions[line], registers, line)
    execute(instructions, registers, line)
  end

  defp execute_line(["set", x, y], registers, line) do
    y_val = get_value(y, registers)
    registers = Map.put(registers, x, y_val)

    {registers, line + 1}
  end

  defp execute_line(["sub", x, y], registers, line) do
    x_val = get_value(x, registers)
    y_val = get_value(y, registers)
    registers = Map.put(registers, x, x_val - y_val)

    {registers, line + 1}
  end

  defp execute_line(["mul", x, y], registers, line) do
    x_val = get_value(x, registers)
    y_val = get_value(y, registers)
    registers =
      registers
      |> Map.put(x, x_val * y_val)
      |> Map.update("count", 1, &(&1 + 1))

    {registers, line + 1}
  end

  defp execute_line(["jnz", x, y], registers, line) do
    x_val = get_value(x, registers)
    y_val = get_value(y, registers)

    if x_val == 0 do
      {registers, line + 1}
    else
      {registers, line + y_val}
    end
  end

  defp get_value(value, _) when is_integer(value), do: value
  defp get_value(value, registers), do: Map.get(registers, value, 0)

  defp parse_line(line) do
    [command | rest] = String.split(line, " ")
    tokens = Enum.map(rest, fn token ->
      case Integer.parse(token) do
        {i, _} -> i
        :error -> token
      end
    end)

    [command | tokens]
  end
end

Day23.main
