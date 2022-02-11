class CovidRawData < ActiveRecord::Migration[6.1]
 def up
    execute <<-SQL
      DO $$ BEGIN
        CREATE TYPE data_sources as ENUM ('OWID', 'Advisory', 'ReopenEU', 'Embassy');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    SQL

    create_table :covid_raw_data do |t|
      t.column :data_source, :data_sources
      t.jsonb :raw_json, default: {}
      t.timestamps
    end
  end
  
  def down
    drop_table :covid_raw_data
    execute <<-SQL
      DROP TYPE IF EXISTS data_sources
    SQL
  end
end
