"./input.txt"
|> File.stream!
|> Stream.map(&String.replace(&1, ~r/\n|:/, ""))
|> Stream.map(&String.split(&1, " "))
|> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
|> Enum.reduce(0, fn [step, depth], sum ->
  if rem(step, (depth - 1) * 2) == 0 do
    sum + depth * step
  else
    sum
  end
end)
|> IO.inspect
