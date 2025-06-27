class FixContractsClientForeignKey < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :contracts, column: :client_id
    add_foreign_key :contracts, :clients, column: :client_id
  end
end
