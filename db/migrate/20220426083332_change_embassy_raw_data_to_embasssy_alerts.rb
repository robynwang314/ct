class ChangeEmbassyRawDataToEmbasssyAlerts < ActiveRecord::Migration[6.1]
  def change
    rename_table :embassy_raw_data, :embassy_alerts
  end
end
