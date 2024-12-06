content = File.read!("input/day2.input")

# levels -> int list
defmodule Safe do

  def is_inc_safe?(levels, count) when count > 1 do
    false
  end

  def is_inc_safe?(levels, count) do
    #IO.inspect(levels ++ count)
    case levels do

      [a,b | tail] when b-a in 1..3 -> is_inc_safe?([b | tail], count)
      [a,b | tail] when b-a not in 1..3 -> is_inc_safe?([a | tail], count+1)

      [] -> true
      [_] -> true
      _ -> false
    end

  end

  def is_dec_safe?(_, count) when count > 1 do
    false
  end

  def is_dec_safe?(levels, count) do
    case levels do

      [a,b | tail] when a-b in 1..3 -> is_dec_safe?([b | tail], count)
      [a,b | tail] when a-b not in 1..3 -> is_dec_safe?([a | tail], count+1)

      [] -> true
      [_] -> true
      _ -> false
    end

  end

  def is_safe?(levels) do
    case levels do
      [a, b | tail] ->
        is_inc_safe?([a,b | tail], 0)
        or is_inc_safe?([b | tail], 1)
        or is_dec_safe?([a,b | tail], 0)
        or is_dec_safe?([b | tail], 1)

      [] -> true
      [_] -> true
      _ -> false

    end
  end

  # order -> 0 (not assigned), 1 (inc), 2 (dec)
  def is_safe_older?(levels, order) do
    case levels do

      [] -> true
      [_] -> true

      [a,b | tail] when order != 2 and b-a in 1..3 -> is_safe_older?([b | tail], 1)
      [a,b | tail] when order != 1 and a-b in 1..3 -> is_safe_older?([b | tail], 2)

      _ -> false

    end
  end
end

levels =
  String.split(content, "\n", trim: true)
  |> Enum.map(fn report -> String.split(report) end)
  |> Enum.map(fn levels -> Enum.map(levels, fn level -> String.to_integer(level) end) end)



safe = Enum.filter(levels, fn levels ->
  Safe.is_safe?(levels)
end)

#IO.inspect(safe, charlists: false)
IO.inspect(length(safe))
