class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :code_postal
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :street
      t.string :complement
      t.string :point_reference
      t.integer :number

      t.timestamps
    end
  end
end
