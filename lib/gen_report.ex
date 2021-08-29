defmodule GenReport do
  alias GenReport.DateHelper

  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  def build(filename) do
    filename
    |> GenReport.Parser.parse_file()
    |> Enum.reduce(report_acc(), &build_report/2)
  end

  def build, do: {:error, "Insira o nome de um arquivo"}

  defp build_report([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = update_submap(hours_per_month, name, month, hours)
    hours_per_year = update_submap(hours_per_year, name, year, hours)

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp update_submap(map, key, subkey, value) do
    submap = Map.put(map[key], subkey, map[key][subkey] + value)
    Map.put(map, key, submap)
  end

  defp report_acc do
    all_hours = Enum.into(@names, %{}, &{&1, 0})

    all_months = Enum.into(DateHelper.months_list(), %{}, &{&1, 0})
    hours_per_month = Enum.into(@names, %{}, &{&1, all_months})

    all_years = Enum.into(2016..2020, %{}, &{&1, 0})
    hours_per_year = Enum.into(@names, %{}, &{&1, all_years})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
