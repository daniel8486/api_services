class CreateEmailDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :email_deliveries do |t|
      t.references :client, null: false, foreign_key: true
      t.references :contract, null: false, foreign_key: true

      t.timestamps
    end
  end
end
