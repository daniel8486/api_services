class AddCepRangeToCities < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :cep_start, :string
    add_column :cities, :cep_end, :string
  end
end
