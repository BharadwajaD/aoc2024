content = File.read!("input")


{left, right } =  String.split(content, "\n", trim: true)
|> Enum.reduce({[], []} , fn line, {left , right} ->
  [a, b] = String.split(line)
  {left ++ [String.to_integer(a)], right ++ [String.to_integer(b)]}
end)


left = Enum.sort(left)
right = Enum.sort(right)

Enum.zip(left, right)
|> Enum.reduce(0, fn {a,b}, acc -> acc + abs(a-b) end)
|> IO.inspect()

Enum.reduce(left, 0 , fn lele, acc ->
  acc + length(Enum.filter(right, fn rele -> lele == rele end)) * lele
end)
|> IO.inspect()
