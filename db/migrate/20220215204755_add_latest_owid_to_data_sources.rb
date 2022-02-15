class AddLatestOwidToDataSources < ActiveRecord::Migration[6.1]
 disable_ddl_transaction!

  def up
    execute "ALTER TYPE data_sources ADD VALUE 'latest OWID'"
  end
end
