defmodule Day4.Part1 do
  @moduledoc """
    This module will work this advent of code challenge https://adventofcode.com/2023/day/1
  """

@input "inputs/day4_input.txt"

  def get_digits() do
    {:ok, contents} = File.read(@input)

      contents
      # Some weird windows character
      |> String.replace("\r", "")
      |> String.split("\n")
      |> map_lines_worth([])
      |> Enum.sum()
  end

  defp map_lines_worth([line], acc) do
    [get_line_worth(line) | acc]
  end

  defp map_lines_worth([line | rest], acc) do
    map_lines_worth(rest, [get_line_worth(line) | acc])
  end

  defp get_line_worth(line) do
    [_card_index, numbers] = String.split(line, ":")

    [result, winners] = String.split(numbers, "|")

    winners =
    Regex.scan(~r/\d+/, winners)
    |> List.flatten()

    Regex.scan(~r/\d+/, result)
    |> Enum.filter(fn [number] -> Enum.member?(winners, number) end)
    |> Enum.reduce(0, fn _, acc -> if acc == 0, do: 1 ,else: acc * 2  end)
  end

end
