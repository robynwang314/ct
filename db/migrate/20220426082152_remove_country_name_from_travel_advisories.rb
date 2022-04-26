class RemoveCountryNameFromTravelAdvisories < ActiveRecord::Migration[6.1]
  def change
    remove_column :travel_advisories, :country_name, :string
  end
end
