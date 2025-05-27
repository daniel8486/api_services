class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :cpf
      t.string :rg
      t.date :dt_expedition
      t.string :organ
      t.string :phone
      t.string :cellphone
      t.date :dt_born
      t.string :nationality

      t.timestamps
    end
  end
end
