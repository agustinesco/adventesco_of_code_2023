defmodule Day1.Part1 do
  @moduledoc """
    This module will work this advent of code challenge https://adventofcode.com/2023/day/1
  """

  @input "inputs/day1_input1.txt"

  def get_digits() do
    {:ok, contents} = File.read(@input)

    contents
    # Some weird windows character
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn line -> find_numbers(line) end)
    |> Enum.sum()
  end

  defp find_numbers(line) do
    fist_number = find_first_number(line, nil)
    last_number = find_first_number(String.reverse(line), nil)

    (fist_number <> last_number)
    |> String.to_integer()
  end

  defp find_first_number(line, number) when is_binary(line),
    do: String.split(line, "") |> find_first_number(number)

  defp find_first_number(_line, number) when not is_nil(number), do: number
  defp find_first_number([], _number), do: nil

  defp find_first_number([char | rest], _number) do
    candidate = if String.match?(char, ~r[\d]), do: char

    find_first_number(rest, candidate)
  end
end
