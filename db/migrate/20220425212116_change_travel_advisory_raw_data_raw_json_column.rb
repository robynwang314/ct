class ChangeTravelAdvisoryRawDataRawJsonColumn < ActiveRecord::Migration[6.1]
  def change
     rename_column :travel_advisory_raw_data, :raw_json, :advisory
  end
end
