class CreateOwidCountryAllTimeData < ActiveRecord::Migration[6.1]
  def up
    create_table :owid_country_all_time_data do |t|
      t.string :country 
      t.jsonb :all_time_data, default: {}
      t.string :data_source, :default => "OWID"
      t.belongs_to :covid_raw_data
      t.timestamps
    end
  end

  def down
    drop_table :owid_country_all_time_data
  end
end
