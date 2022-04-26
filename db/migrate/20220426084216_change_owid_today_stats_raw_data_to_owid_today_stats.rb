class ChangeOwidTodayStatsRawDataToOwidTodayStats < ActiveRecord::Migration[6.1]
  def change
    rename_table :owid_today_stats_raw_data, :owid_today_stats
  end
end
