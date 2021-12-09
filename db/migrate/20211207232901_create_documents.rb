class CreateDocuments < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      DO $$ BEGIN
        CREATE TYPE document_types as ENUM ('vaccine', 'test');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    SQL

    create_table :documents do |t|
      t.column :document_type, :document_types
      t.boolean :required, :default => false
      t.boolean :antigen, :default => false
      t.boolean :pcr, :default => false
      t.string :validity
      t.jsonb :data, default: {}
      t.belongs_to :country, null: false, foreign_key: true

      t.timestamps
    end
  end
  
  def down
    drop_table :documents
    execute <<-SQL
      DROP TYPE IF EXISTS document_types
    SQL
  end
end
