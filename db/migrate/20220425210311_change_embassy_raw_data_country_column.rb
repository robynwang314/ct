class ChangeEmbassyRawDataCountryColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :embassy_raw_data, :country, :country_name
  end
end
