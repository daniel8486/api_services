class AddDocumentToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :document, :string
  end
end
