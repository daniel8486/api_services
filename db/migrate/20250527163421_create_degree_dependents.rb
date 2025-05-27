class CreateDegreeDependents < ActiveRecord::Migration[8.0]
  def change
    create_table :degree_dependents do |t|
      t.string :description
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
