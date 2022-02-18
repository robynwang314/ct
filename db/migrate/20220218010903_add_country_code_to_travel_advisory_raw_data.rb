class AddCountryCodeToTravelAdvisoryRawData < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_advisory_raw_data, :country_code, :string
  end
end
