class ChangeCountryNameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :countries, :name, :country
  end
end
