defmodule Day3.Part2 do
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

      Regex.scan(~r/\*/, line, return: :index)
      |> find_nearby_numbers(line, previous, next)
    end)
    |> Enum.reject(fn line -> Enum.empty?(line) end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp find_nearby_numbers(number_indexes, line, previous_line, next_line) do
    line_length = String.length(line)

    Enum.reduce(number_indexes, [], fn
      [{match_init, match_size}], acc ->
        numbers_on_sides =
          Regex.scan(~r/(\d*)(\*)(\d*)/, line, return: :index)
          |> Enum.find(fn [_, _, {asterisk_init, asterik_size}, _] ->
            asterisk_init == match_init and match_size == asterik_size
          end)
          |> case do
            nil ->
              []

            [_, {left_number_init, left_number_size}, _, {right_number_init, right_number_size}] ->
              left_number =
                String.slice(line, left_number_init, left_number_size)
                |> case do
                  "" -> nil
                  number -> String.to_integer(number)
                end

              right_number =
                String.slice(line, right_number_init, right_number_size)
                |> case do
                  "" -> nil
                  number -> String.to_integer(number)
                end
              [left_number, right_number]
              |> Enum.reject(fn n -> is_nil(n) end)
          end

        result =
          numbers_on_sides ++
            find_numbers_in_line(
              map_number_indexes(previous_line),
              previous_line,
              match_init,
              match_size,
              line_length
            ) ++
            find_numbers_in_line(
              map_number_indexes(next_line),
              next_line,
              match_init,
              match_size,
              line_length
            )

        case result do
          [number1, number2] -> [number1 * number2 | acc]
          _ -> acc
        end
    end)
  end

  defp map_number_indexes(nil), do: nil
  defp map_number_indexes(line), do: Regex.scan(~r/\d+/, line, return: :index)

  defp find_numbers_in_line(nil, _line, _start_index, _length, _line_length), do: []

  defp find_numbers_in_line(line_with_indexes_mapped, line, start_index, length, line_length) do
    start_index = if start_index == 0, do: 0, else: start_index - 1
    length = if start_index + length + 1 == line_length, do: length, else: length + 1

    Enum.reduce(start_index..(start_index + length), [], fn index, acc ->
      case Enum.find(line_with_indexes_mapped, fn [{number_start, number_length}] ->
             number_start <= index and index <= number_start + number_length - 1
           end) do
        nil ->
          acc

        [number_position] ->
          acc ++ [number_position]
      end
    end)
    |> Enum.map(fn {start, lenght} -> String.slice(line, start, lenght) |> String.to_integer() end)
    |> Enum.uniq()
  end
end
