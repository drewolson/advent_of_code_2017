digits =
  "./input.txt"
  |> File.read!
  |> String.trim
  |> String.graphemes
  |> Enum.map(&String.to_integer/1)

pairs =
  digits
  |> Stream.cycle
  |> Stream.drop(1)

digits
|> Enum.zip(pairs)
|> Enum.filter(&match?({a, a}, &1))
|> Enum.map(&elem(&1, 0))
|> Enum.sum
|> IO.inspect
