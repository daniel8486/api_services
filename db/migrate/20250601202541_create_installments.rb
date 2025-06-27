class CreateInstallments < ActiveRecord::Migration[8.0]
  def change
    create_table :installments do |t|
      t.references :contract, null: false, foreign_key: true
      t.integer :numero
      t.decimal :valor
      t.date :vencimento
      t.date :data_pagamento
      t.string :status

      t.timestamps
    end
  end
end
