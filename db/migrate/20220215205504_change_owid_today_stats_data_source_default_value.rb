class ChangeOwidTodayStatsDataSourceDefaultValue < ActiveRecord::Migration[6.1]
 disable_ddl_transaction!

  def up
    execute "ALTER TABLE ONLY owid_today_stats_raw_data ALTER COLUMN data_source SET DEFAULT 'latest OWID'"
  end
end
