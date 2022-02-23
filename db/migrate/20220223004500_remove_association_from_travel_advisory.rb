class RemoveAssociationFromTravelAdvisory < ActiveRecord::Migration[6.1]
  def change
    remove_reference :travel_advisory_raw_data, :covid_raw_data, index: true
  end
end
