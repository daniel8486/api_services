class CreatePendingImportTables < ActiveRecord::Migration[8.0]
  def change
     create_table :pending_import_tables do |t|
      t.string :table_name
      t.string :schema
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.datetime :expires_at
      t.timestamps
    end
  end
end
