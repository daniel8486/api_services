class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.integer :code
      t.string :name
      t.references :state, null: false, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.boolean :capital
      t.string :ddd
      t.string :timezone

      t.timestamps
    end
  end
end
