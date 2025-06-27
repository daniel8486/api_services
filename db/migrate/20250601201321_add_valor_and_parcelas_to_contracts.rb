class AddValorAndParcelasToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :valor, :decimal
    add_column :contracts, :parcelas, :integer
  end
end
