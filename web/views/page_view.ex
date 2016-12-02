defmodule Departures.PageView do
  use Departures.Web, :view

  def departures do
    "Departures.csv" |>
    File.stream! |>
    CSV.decode(headers: true)
  end

  def epoch_to_local(epoch) do
    epoch |>
    Timex.parse!("{s-epoch}") |>
    Timex.Timezone.convert("America/New_York") |>
    Timex.Format.DateTime.Formatter.format!("{h12}:{m} {AM}")
  end
end
