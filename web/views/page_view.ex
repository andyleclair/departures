defmodule Departures.PageView do
  use Departures.Web, :view
	alias NimbleCSV.RFC4180, as: CSV

  @mbta_url "http://developer.mbta.com/lib/gtrtfs/Departures.csv"

  def departures do
    HTTPoison.get!(@mbta_url).body |>
    CSV.parse_string |>
		Enum.map(fn [timestamp, origin, trip, destination, scheduled_time, lateness, track, status] ->
			%{timestamp: timestamp, origin: origin, trip: trip,
				destination: destination, scheduled_time: epoch_to_local(scheduled_time),
				lateness: lateness, track: track, status: status}
		end)
  end

  defp epoch_to_local(epoch) do
    epoch |>
    Timex.parse!("{s-epoch}") |>
    Timex.Timezone.convert("America/New_York") |>
    Timex.Format.DateTime.Formatter.format!("{h12}:{m} {AM}")
  end
end
