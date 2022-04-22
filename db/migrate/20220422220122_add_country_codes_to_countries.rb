class AddCountryCodesToCountries < ActiveRecord::Migration[6.1]
  def change
    add_column :countries, :alpha2, :string, unique: true
    add_column :countries, :alpha3, :string, unique: true
  end
end
