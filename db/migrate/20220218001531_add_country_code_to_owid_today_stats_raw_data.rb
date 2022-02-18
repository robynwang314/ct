class AddCountryCodeToOwidTodayStatsRawData < ActiveRecord::Migration[6.1]
  def change
    add_column :owid_today_stats_raw_data, :country_code, :string
  end
end
