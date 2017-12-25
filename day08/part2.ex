defmodule Day08 do
  @input "./input.txt"

  def main do
    @input
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_line/1)
    |> Enum.reduce({%{}, 0}, fn f, {map, max} ->
      map = f.(map)

      {map, Enum.max([max | Map.values(map)])}
    end)
    |> elem(1)
    |> IO.inspect
  end

  def parse_line([dest, op, v1, "if", source, pred, v2]) do
    op = if op == "inc", do: :+, else: :-
    pred = String.to_atom(pred)

    v1 = String.to_integer(v1)
    v2 = String.to_integer(v2)

    fn map ->
      if apply(Kernel, pred, [Map.get(map, source, 0), v2]) do
        default = apply(Kernel, op, [v1])

        Map.update(map, dest, default, fn current ->
          apply(Kernel, op, [current, v1])
        end)
      else
        map
      end
    end
  end
end

Day08.main
