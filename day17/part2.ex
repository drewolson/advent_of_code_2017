Stream.unfold({0, 1}, fn {pos, i} ->
  step = rem(312, i)
  new_pos = rem(pos + step, i) + 1

  {{new_pos, i}, {new_pos, i + 1}}
end)
|> Stream.take(50_000_000)
|> Stream.filter(&(elem(&1, 0) == 1))
|> Enum.to_list
|> List.last
|> elem(1)
|> IO.inspect
