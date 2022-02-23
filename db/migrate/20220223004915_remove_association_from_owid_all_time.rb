class RemoveAssociationFromOwidAllTime < ActiveRecord::Migration[6.1]
  def change
    remove_reference :owid_country_all_time_data, :covid_raw_data, index: true
  end
end
