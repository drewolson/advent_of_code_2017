1..2017
|> Enum.reduce([0], fn item, spinlock ->
  spinlock =
    spinlock
    |> Stream.cycle
    |> Stream.drop(rem(312 + 1, item))
    |> Enum.take(item)

  [item | spinlock]
end)
|> Enum.drop(1)
|> hd
|> IO.inspect
