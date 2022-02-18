class CreateReopenEuByCountries < ActiveRecord::Migration[6.1]
  def up
    create_table :reopen_eu_by_countries do |t|
      t.string :country 
      t.string :country_code
      t.jsonb :raw_json, default: {}
      t.string :data_source, :default => "ReopenEU"
      t.belongs_to :covid_raw_data
      t.timestamps
    end
  end

  def down
    drop_table :reopen_eu_by_countries
  end
end
