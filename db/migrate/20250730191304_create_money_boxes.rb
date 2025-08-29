class CreateMoneyBoxes < ActiveRecord::Migration[8.0]
  def change
    create_table :money_boxes do |t|
      t.decimal :opening_value
      t.decimal :closing_value
      t.references :user, null: false, foreign_key: true
      t.decimal :withdrawal_cash
      t.text :observation

      t.timestamps
    end
  end
end
