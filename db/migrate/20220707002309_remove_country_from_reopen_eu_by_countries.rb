class RemoveCountryFromReopenEuByCountries < ActiveRecord::Migration[6.1]
  def change
    remove_column :reopen_eu_by_countries, :country, :string
  end
end
