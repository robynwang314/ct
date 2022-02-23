class DropChartTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :charts
  end
end
