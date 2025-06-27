class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.references :company, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.decimal :discount_percentage
      t.string :payment_method

      t.timestamps
    end
  end
end
