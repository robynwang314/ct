class RemoveAssociationFromOwidToday < ActiveRecord::Migration[6.1]
  def change
    remove_reference :owid_today_stats_raw_data, :covid_raw_data, index: true
  end
end
