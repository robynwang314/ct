class ChangeOwidTodayStatsRawJsonColumnToTodaysStats < ActiveRecord::Migration[6.1]
  def change
    rename_column :owid_today_stats, :raw_json, :todays_stats
  end
end
