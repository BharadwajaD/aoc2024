content = File.read!("input/day3.input")

defmodule AOC24 do

  def multiply(str) do
    [num1, num2] = Regex.scan(~r{[0-9]+}, str) |> List.flatten()
    String.to_integer(num1)* String.to_integer(num2)
  end
end

muls = Regex.scan( ~r{mul\(\d+,\d+\)}, content)
  |> List.flatten()

Enum.reduce(muls, 0, fn mul, acc ->
  acc + AOC24.multiply(mul)
end)
|> IO.inspect()

muls = Regex.scan( ~r{don't|do|mul\(\d+,\d+\)}, content)
  |> List.flatten()
  |> IO.inspect()


{to_mul, _ } = Enum.reduce(muls, {[], false}, fn mul, {acc, ignore} ->
  cond do
    mul == "do" ->
      {acc, false}
    mul == "don't" ->
      {acc, true}
    ignore -> {acc, ignore}
    true -> {[mul | acc], ignore}
  end
end)

Enum.reduce(to_mul, 0, fn mul , acc ->
  acc + AOC24.multiply(mul)
end)
|> IO.inspect()
