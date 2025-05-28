class AddTypeDocumentToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_reference :documents, :type_document, null: false, foreign_key: true
  end
end
