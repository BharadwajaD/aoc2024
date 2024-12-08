content = File.read!("./input/day4.input")


defmodule AOC24 do

  def search(_, %{:to_search_for => to_search_for, :update => _, :curr => _}) when to_search_for == [] do
    1
  end

  def search(mp, %{:to_search_for => to_search_for, :update => {rowu, colu}, :curr => {rowc, colc}}) do

    [search_ele | to_search_for] = to_search_for
    {row, col} = {rowc + rowu, colc + colu}
    if search_ele == Map.get(mp, "#{row}:#{col}") do
      search(mp, %{:to_search_for => to_search_for, :update => {rowu, colu}, :curr => {row, col}})
    else
      0
    end
  end

  def grid_to_str(grid) do

    str = Enum.reduce(grid, "", fn line , str ->
      str <> Enum.reduce(line, "", fn char, str ->
        str <> char
      end)
    end)
    str

  end

  def str_match(str1, str2) do

    c1 = String.graphemes(str1)
    c2 = String.graphemes(str2)

    Enum.zip(c1, c2)
    |> Enum.reduce_while(false, fn {c1, c2}, _ ->
        if (c1 == c2 or c2 == "*") do
          {:cont, true}
        else
          {:halt, false}
        end
      end)


  end

  def match_box(_, %{:update => {rowu, colu}, :curr => {rowc, colc}, :len => {rowl, coll}})
    when  rowc + rowu >= rowl or colc + colu >= coll
  do
    false
  end

  # to_search_for is a 2d grid
  def match_box(mp, %{:to_search_for => to_search_for, :update => update, :curr => curr, :len => _}) do

    {rowc, colc} = curr
    {rowu, colu} = update

    ref_grid = Enum.reduce(rowc..(rowc + rowu), [], fn row, acc ->
      acc ++ [Enum.reduce(colc .. (colc + colu), [], fn col, acc ->
        key = "#{row}:#{col}"
        acc ++ [Map.get(mp, key, [])]
      end)]
    end)

    ref_grid_str = grid_to_str(ref_grid)
    grid_str = grid_to_str(to_search_for)

    str_match(ref_grid_str, grid_str)

  end

end

{rows, mp} = String.split(content, "\n", trim: true)
|> Enum.reduce({0, %{}}, fn line, {row, mp} ->

  {_, umap} = String.graphemes(line) |> Enum.reduce({0, %{}}, fn char, {col, i_mp} ->
      {col + 1, Map.put_new(i_mp, "#{row}:#{col}", char)}
    end)

  {row + 1, Map.merge(mp, umap)}
end)

cols = div(Kernel.map_size(mp),rows)

xmas_cnt = Enum.reduce(0..rows-1, 0, fn row, acc ->
   acc + Enum.reduce(0..cols-1, 0, fn col, acc ->
    key = "#{row}:#{col}"
    ele = Map.get(mp, key)
    if ele == "X" do
      s1 = AOC24.search(mp, %{:to_search_for => ["M", "A", "S"], :update => { 0,  1}, :curr => {row, col}})
      s2 = AOC24.search(mp, %{:to_search_for => ["M", "A", "S"], :update => { 1,  0}, :curr => {row, col}})
      s3 = AOC24.search(mp, %{:to_search_for => ["M", "A", "S"], :update => { 1,  1}, :curr => {row, col}})
      s4 = AOC24.search(mp, %{:to_search_for => ["M", "A", "S"], :update => { 1, -1}, :curr => {row, col}})
      acc + s1 + s2 + s3 + s4
    else
      acc
    end
  end)
end)

samx_cnt = Enum.reduce(0..rows-1, 0, fn row, acc ->
   acc + Enum.reduce(0..cols-1, 0, fn col, acc ->
    key = "#{row}:#{col}"
    ele = Map.get(mp, key)
    if ele == "S" do
      s1 = AOC24.search(mp, %{:to_search_for => ["A", "M", "X"], :update => { 0,  1}, :curr => {row, col}})
      s2 = AOC24.search(mp, %{:to_search_for => ["A", "M", "X"], :update => { 1,  0}, :curr => {row, col}})
      s3 = AOC24.search(mp, %{:to_search_for => ["A", "M", "X"], :update => { 1,  1}, :curr => {row, col}})
      s4 = AOC24.search(mp, %{:to_search_for => ["A", "M", "X"], :update => { 1, -1}, :curr => {row, col}})
      acc + s1 + s2 + s3 + s4
    else
      acc
    end
  end)
end)

IO.inspect("part1.....#{xmas_cnt + samx_cnt}")

search_grid1 = [["M", "*", "S"], ["*", "A", "*"], ["M", "*", "S"]]
search_grid2 = [["M", "*", "M"], ["*", "A", "*"], ["S", "*", "S"]]
search_grid3 = [["S", "*", "M"], ["*", "A", "*"], ["S", "*", "M"]]
search_grid4 = [["S", "*", "S"], ["*", "A", "*"], ["M", "*", "M"]]

IO.inspect("part2 ...")
Enum.reduce(0..rows-1, 0, fn row, acc ->
   acc + Enum.reduce(0..cols-1, 0, fn col, acc ->
    if(
         AOC24.match_box(mp, %{:to_search_for => search_grid1, :update => {2, 2}, :curr => {row, col}, :len => {rows, cols}})
      or AOC24.match_box(mp, %{:to_search_for => search_grid2, :update => {2, 2}, :curr => {row, col}, :len => {rows, cols}})
      or AOC24.match_box(mp, %{:to_search_for => search_grid3, :update => {2, 2}, :curr => {row, col}, :len => {rows, cols}})
      or AOC24.match_box(mp, %{:to_search_for => search_grid4, :update => {2, 2}, :curr => {row, col}, :len => {rows, cols}})
    ) do

      acc + 1
    else
      acc
    end
  end)
end)
  |> IO.inspect()
