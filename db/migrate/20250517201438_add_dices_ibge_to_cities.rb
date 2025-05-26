class AddDicesIbgeToCities < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :name_ibge, :string
  end
end
