content = File.read!("./input/day5.input")
[dependencies , updates | _ ] = String.split(content, "\n\n")

defmodule AOC24 do

  def construct_map_set(list_deps) do
    Enum.reduce(list_deps, %{}, fn {pre, post}, acc ->
      Map.update(acc, pre, MapSet.new([post]), fn set  ->
        MapSet.put(set, post)
      end)
    end)
  end

  def is_correct_update?(map_set, update) do

    truth = case update do
      [page] ->
        fn  ->
          true
      end.()
      [page | latter_pg] ->
        fn  ->
          val = is_correct_update?(map_set, latter_pg) and
            MapSet.subset?(MapSet.new(latter_pg), Map.get(map_set, page, MapSet.new([])))
          val
      end.()

      _ -> false
    end
  end

  def cnt_pres(map_set, list) do
    Enum.reduce(list, %{}, fn pre, acc ->
      inner = Enum.reduce(list, %{}, fn post, inner ->
        inner = Map.put(inner, post, 0)
        if MapSet.member?(Map.get(map_set, pre, MapSet.new([])), post) do
          Map.update(inner, post, 1, fn val -> val + 1 end)
        else
          inner
        end
      end)

      Map.merge(acc, inner, fn _k, v1, v2 -> v1+v2 end)
    end)
  end

end

list_deps =
  String.split(dependencies, "\n", trim: true)
  |> Enum.map(fn ele ->
    [n1, n2 | _ ] = String.split(ele, "|")
    {String.to_integer(n1), String.to_integer(n2)}
  end)

updates =
  String.split(updates, "\n", trim: true)
  |> Enum.map(fn update_line ->
    String.split(update_line, ",")
    |> Enum.map(fn ele ->  String.to_integer(ele) end)
  end)



map_set = AOC24.construct_map_set(list_deps)


Enum.reduce(updates, 0, fn update, acc ->
  if AOC24.is_correct_update?(map_set, update) do
    acc + Enum.at(update, div(length(update), 2))
  else
    acc
  end
end)
|> IO.inspect()


Enum.reduce(updates, 0, fn update, acc ->
  if not AOC24.is_correct_update?(map_set, update) do
    {k, _} =  AOC24.cnt_pres(map_set, update)
    |> Enum.sort(fn {_, v1}, {_, v2} -> v1 < v2 end)
    |> Enum.at(div(length(update), 2))

    acc + k
  else
    acc
  end
end)
|> IO.inspect()
