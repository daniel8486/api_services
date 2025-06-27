class AddDataContratoToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :data_contrato, :date
  end
end
