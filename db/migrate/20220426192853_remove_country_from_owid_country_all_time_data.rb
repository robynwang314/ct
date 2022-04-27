class RemoveCountryFromOwidCountryAllTimeData < ActiveRecord::Migration[6.1]
  def change
     remove_column :owid_country_all_time_data, :country, :string
  end
end
