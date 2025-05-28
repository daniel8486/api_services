class AddClientIdToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :client_id, :integer
  end
end
