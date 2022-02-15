class CreateOwidTodayStatsRawData < ActiveRecord::Migration[6.1]
  def up
    create_table :owid_today_stats_raw_data do |t|
      t.string :country 
      t.jsonb :raw_json, default: {}
      t.string :data_source, :default => "OWID"
      t.belongs_to :covid_raw_data
      t.timestamps
    end
  end

  def down
    drop_table :owid_today_stats_raw_data
  end
end
