defmodule Day1.Part2 do
  @moduledoc """
    This module will work this advent of code challenge https://adventofcode.com/2023/day/1
  """

  @input "inputs/day1_input2.txt"

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
    fist_number = find_first_number(line, "", nil)
    last_number = find_first_number(String.reverse(line), "", nil)

    (fist_number <> last_number)
    |> String.to_integer()
  end

  defp find_first_number(line, acc, number) when is_binary(line),
    do: String.split(line, "") |> find_first_number(acc, number)

  defp find_first_number(_line, _acc, number) when not is_nil(number), do: number
  defp find_first_number([], _acc, _number), do: nil

  defp find_first_number([char | rest], acc, _number) do
    candidate = acc <> char

    find_first_number(rest, candidate, to_integer(char, candidate))
  end

  defp to_integer(char, word) do
    cond do
      String.match?(word, ~r[one|eno]) -> "1"
      String.match?(word, ~r[two|owt]) -> "2"
      String.match?(word, ~r[three|eerht]) -> "3"
      String.match?(word, ~r[four|ruof]) -> "4"
      String.match?(word, ~r[five|evif]) -> "5"
      String.match?(word, ~r[six|xis]) -> "6"
      String.match?(word, ~r[seven|neves]) -> "7"
      String.match?(word, ~r[eight|thgie]) -> "8"
      String.match?(word, ~r[nine|enin]) -> "9"
      String.match?(char, ~r[\d]) -> char
      true -> nil
    end
  end
end
