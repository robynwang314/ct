class CreateEmbassyGeneralAlerts < ActiveRecord::Migration[6.1]
  def change
    create_table :embassy_general_alerts do |t|
      t.string :country_name
      t.jsonb :advisory, default: {}
      t.jsonb :messages, default: {}
      t.jsonb :quick_facts, default: {}
      t.jsonb :entry_exit_requirements, default: {}
      t.jsonb :safety_and_security, default: {}
      t.timestamps
    end
  end
end
