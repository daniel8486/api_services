class CreateZips < ActiveRecord::Migration[8.0]
  def change
    create_table :zips do |t|
      t.string :code
      t.string :street
      t.references :neighborhood, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
