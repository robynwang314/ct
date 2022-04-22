class ChangeTravelAdvisoryRawDataCountryColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :travel_advisory_raw_data, :country, :country_name
  end
end
