class AddDicesToNeighborhoods < ActiveRecord::Migration[8.0]
  def change
    add_column :neighborhoods, :locality, :string
  end
end
