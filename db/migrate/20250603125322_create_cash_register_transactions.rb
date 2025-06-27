class CreateCashRegisterTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_register_transactions do |t|
      t.references :cash_register, null: false, foreign_key: true
      t.references :installment, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.decimal :valor
      t.string :tipo
      t.datetime :data
      t.decimal :troco
      t.string :observacao

      t.timestamps
    end
  end
end
