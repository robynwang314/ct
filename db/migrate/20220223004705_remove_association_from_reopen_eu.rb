class RemoveAssociationFromReopenEu < ActiveRecord::Migration[6.1]
  def change
    remove_reference :reopen_eu_by_countries, :covid_raw_data, index: true
  end
end
