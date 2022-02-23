class RemoveAssociationFromEmbassyRawData < ActiveRecord::Migration[6.1]
  def change
    remove_reference :embassy_raw_data, :covid_raw_data, index: true
  end
end
