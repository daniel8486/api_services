class CreateCashRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_registers do |t|
      t.decimal :opening_value
      t.decimal :closing_value
      t.datetime :opened_at
      t.datetime :closed_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
