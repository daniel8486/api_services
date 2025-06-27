class AddCompanyIdToContracts < ActiveRecord::Migration[8.0]
  def change
    add_reference :contracts, :company, null: false, foreign_key: true
  end
end
