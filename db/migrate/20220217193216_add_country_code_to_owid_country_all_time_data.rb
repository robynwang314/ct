class AddCountryCodeToOwidCountryAllTimeData < ActiveRecord::Migration[6.1]
  def change
    add_column :owid_country_all_time_data, :country_code, :string
  end
end
