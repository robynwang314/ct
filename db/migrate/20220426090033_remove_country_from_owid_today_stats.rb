class RemoveCountryFromOwidTodayStats < ActiveRecord::Migration[6.1]
  def change
    remove_column :owid_today_stats, :country, :string
  end
end
