defmodule CSys.CourseScript do
  @moduledoc """
  脚本
  """

  alias CSys.CourseDao

  @doc """
  CSys.CourseScript.translate_location("Track and Field", "Athletic Field(GPCP Stadium)")
  """
  def translate_location(src_str, new_str) do
    result =
    CourseDao.list_courses_all
    |> Enum.filter(fn course ->
      if course.venue |> contains(src_str) do
        ## update
        new_venue = course.venue |> replace(src_str, new_str)
        course |> CourseDao.update_course(%{venue: new_venue})
      end
    end)
    IO.puts "<<<< Updated count: #{length(result)} >>>>"
  end

  defp contains(venue, src_str) do
    much =
    venue
    |> Enum.filter(fn v ->
      %{
        "week" => week,
        "day" => day,
        "time" => time,
        "location" => location
      } = v
      if location do
        if location |> String.contains?(src_str) do
          true
        end
      end
    end)
    much != [] # means no one contains src_str
  end

  defp replace(venue, src_str, new_str) do
    venue
    |> Enum.map(fn v ->
      %{
        "week" => week,
        "day" => day,
        "time" => time,
        "location" => location
      } = v
      if location != nil and location |> String.contains?(src_str) do
        %{
          "week" => week,
          "day" => day,
          "time" => time,
          "location" => location |> String.replace(src_str, new_str)
        }
      else
        v
      end
    end)
  end
end
