defmodule Day2.Part1 do
  @cubes %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  @input "inputs/day2_input1.txt"

  def get_possible_games() do
    {:ok, contents} = File.read(@input)

    contents
    |> String.replace("\r", "") # Some weird windows character
    |> String.split("\n")
    |> Enum.reject(fn cubes ->
      [_id, cube_numbers] = String.split(cubes, ": ")
      is_game_impossible?(cube_numbers)
    end)
    |> Enum.map(fn line ->
      [_line, line_id] = Regex.run(~r[Game (\d+):.*], line)
      String.to_integer(line_id)
    end)
    |> Enum.sum()
  end

  defp is_game_impossible?(cubes) do
    red_regex = ~r[(\d+) red]
    blue_regex = ~r[(\d+) blue]
    green_regex = ~r[(\d+) green]

    red_cubes =
      Regex.scan(red_regex, cubes)
      |> Enum.any?(fn [_, amount] -> String.to_integer(amount) > @cubes["red"] end)

    blue_cubes =
      Regex.scan(blue_regex, cubes)
      |> Enum.any?(fn [_, amount] -> String.to_integer(amount) > @cubes["blue"] end)

    green_cubes =
      Regex.scan(green_regex, cubes)
      |> Enum.any?(fn [_, amount] -> String.to_integer(amount) > @cubes["green"] end)

    red_cubes || blue_cubes || green_cubes
  end
end
