content = File.read!("input.test")

# levels -> int list
defmodule Safe do

  def is_safe?(level) do
  end

end

levels = String.split(content, "\n", trim: true)
|> Enum.map(fn report ->
  String.split(report) |> Enum.map(fn level -> String.to_integer(level) end)
end)
  |> IO.inspect()


Enum.reduce(levels, 0, fn level, acc ->
  if Safe.is_safe?(level) do
    acc + 1
  end
end)
|> IO.inspect()
