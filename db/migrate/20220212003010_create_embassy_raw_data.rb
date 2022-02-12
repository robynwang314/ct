class CreateEmbassyRawData < ActiveRecord::Migration[6.1]
  def up
    create_table :embassy_raw_data do |t|
      t.string :country 
      t.jsonb :raw_json, default: {}
      t.string :data_source, :default => "Embassy"
      t.belongs_to :covid_raw_data
      t.timestamps
    end
  end

  def down
    drop_table :embassy_raw_data
  end
end
