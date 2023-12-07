defmodule Day2.Part2 do
  @input "inputs/day2_input1.txt"

  def get_possible_games() do
    {:ok, contents} = File.read(@input)

    contents
    |> String.replace("\r", "") # Some weird windows character
    |> String.split("\n")
    |> Enum.map(fn cubes ->
      [_id, cube_numbers] = String.split(cubes, ": ")
      get_match_power(cube_numbers)
    end)
    |> Enum.sum()
  end

  defp get_match_power(cubes) do
    red_regex = ~r[(\d+) red]
    blue_regex = ~r[(\d+) blue]
    green_regex = ~r[(\d+) green]

    red_cubes =
      Regex.scan(red_regex, cubes)
      |> Enum.map(fn [_, amount] -> String.to_integer(amount) end)
      |> Enum.max()

    blue_cubes =
      Regex.scan(blue_regex, cubes)
      |> Enum.map(fn [_, amount] -> String.to_integer(amount) end)
      |> Enum.max()

    green_cubes =
      Regex.scan(green_regex, cubes)
      |> Enum.map(fn [_, amount] -> String.to_integer(amount) end)
      |> Enum.max()

    red_cubes * blue_cubes * green_cubes
  end
end
