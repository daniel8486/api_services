class AddFilesToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :files, :string
  end
end
