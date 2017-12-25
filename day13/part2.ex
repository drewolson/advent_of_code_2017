firewall =
  "./input.txt"
  |> File.stream!
  |> Stream.map(&String.replace(&1, ~r/\n|:/, ""))
  |> Stream.map(&String.split(&1, " "))
  |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))

0
|> Stream.iterate(&(&1 + 1))
|> Enum.find(fn offset ->
  Enum.all?(firewall, fn [step, depth] ->
    rem(step + offset, (depth - 1) * 2) != 0
  end)
end)
|> IO.inspect
