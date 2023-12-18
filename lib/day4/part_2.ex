defmodule Day4.Part2 do
  @moduledoc """
    This module will work this advent of code challenge https://adventofcode.com/2023/day/1
  """

@input "inputs/day4_input.txt"

  def get_digits() do
    {:ok, contents} = File.read(@input)

    original_cards =
        contents
        # Some weird windows character
        |> String.replace("\r", "")
        |> String.split("\n")
        |> map_lines_worth([])
        |> Enum.reverse()

    summ_card_amounts(original_cards, Map.new(original_cards), %{})
    |> Map.values()
    |> Enum.sum()
  end

  defp map_lines_worth([line], acc) do
    [get_line_grow(line) | acc]
  end

  defp map_lines_worth([line | rest], acc) do
    map_lines_worth(rest, [get_line_grow(line) | acc])
  end

  defp get_line_grow(line) do
    [card_index, numbers] = String.split(line, ":")

    [result, winners] = String.split(numbers, "|")

    winners =
    Regex.scan(~r/\d+/, winners)
    |> List.flatten()

    card_worth =
      Regex.scan(~r/\d+/, result)
      |> Enum.filter(fn [number] -> Enum.member?(winners, number) end)
      |> length()

    card_number =
      Regex.run(~r/\d+/, card_index)
      |> hd()
      |> String.to_integer()

    {card_number, card_worth}
  end

  defp summ_card_amounts([{card_index, 0}], _card_map, acc), do: add_or_summ_card_amount(acc, card_index)
  defp summ_card_amounts([{card_index, 0} | tail], card_map, acc) do
    summ_card_amounts(tail, card_map, add_or_summ_card_amount(acc, card_index))
  end
  defp summ_card_amounts([{card_index, card_worth} | tail], card_map, acc) do
    cards_to_add =
      Enum.reduce(card_index + 1..card_index + card_worth, [], fn index, acc ->
        worth = Map.get(card_map, index)

        [{index, worth} | acc]
      end)

    next_iteration_cards =
      Enum.reduce(cards_to_add, tail, fn card, acc -> [card | acc] end)

    summ_card_amounts(next_iteration_cards, card_map, add_or_summ_card_amount(acc, card_index))
  end

  defp add_or_summ_card_amount(cards, index) do
    case Map.get(cards, index) do
      nil -> Map.put(cards, index, 1)
      number -> Map.put(cards, index, number + 1)
    end
  end
end
