class AddHrefToCountry < ActiveRecord::Migration[6.1]
  def change
    add_column :countries, :href, :string
  end
end
