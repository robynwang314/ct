class ChangeEmbassyAlertsToEmbassyCovidAlerts < ActiveRecord::Migration[6.1]
  def change
     rename_table :embassy_alerts, :embassy_covid_alerts
  end
end
