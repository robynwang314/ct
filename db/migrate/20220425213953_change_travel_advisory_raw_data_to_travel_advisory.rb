class ChangeTravelAdvisoryRawDataToTravelAdvisory < ActiveRecord::Migration[6.1]
  def change
    rename_table :travel_advisory_raw_data, :travel_advisories
  end
end
