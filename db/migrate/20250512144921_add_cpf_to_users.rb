class AddCpfToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :cpf, :string
    add_index :users, :cpf, unique: true
  end
end
