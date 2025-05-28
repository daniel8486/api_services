class RemoveClientIdFromClients < ActiveRecord::Migration[8.0]
  def change
    remove_column :clients, :client_id, :bigint
  end
end
