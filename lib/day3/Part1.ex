defmodule Day3.Part1 do
  @moduledoc """
    This module will work this advent of code challenge https://adventofcode.com/2023/day/1
  """

  @input "inputs/day3_input.txt"

  def get_digits() do
    {:ok, contents} = File.read(@input)

    lines_maped =
      contents
      # Some weird windows character
      |> String.replace("\r", "")
      |> String.split("\n")
      |> Enum.with_index()
      |> Map.new(fn {line, index} -> {index, line} end)

    get_numbers(lines_maped)
  end

  defp get_numbers(lines_mapped) do
    lines_mapped
    |> Enum.map(fn {index, line} ->
      previous = lines_mapped[index - 1]
      next = lines_mapped[index + 1]

      Regex.scan(~r/\d+/, line, return: :index)
      |> filter_out_invalid_words(line, previous, next)
      |> Enum.map(fn [{start_index, string_length}] ->
        String.slice(line, start_index, string_length)
        |> String.to_integer()
      end)
    end)
    |> Enum.reject(fn line -> Enum.empty?(line) end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp filter_out_invalid_words(number_indexes, line, previous_line, next_line) do
    line_length = String.length(line)

    Enum.filter(number_indexes, fn
      [{match_init, match_size}] ->
        any_special_character_in_line?(line, match_init, match_size, line_length) ||
          any_special_character_in_line?(previous_line, match_init, match_size, line_length) ||
          any_special_character_in_line?(next_line, match_init, match_size, line_length)
    end)
  end

  defp any_special_character_in_line?(nil, _start_index, _length, _line_length), do: false

  defp any_special_character_in_line?(line, start_index, length, line_length) do
    start_index = if start_index == 0, do: 0, else: start_index - 1
    length = if start_index + length + 1 == line_length, do: length, else: length + 2
    sliced = String.slice(line, start_index, length)
    Regex.match?(~r/[^\d\.]/, sliced)
  end
end
