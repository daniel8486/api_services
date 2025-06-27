class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.integer :client_id
      t.references :company, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.references :campaign, foreign_key: true # null: true por padrão
      t.string :details
      t.decimal :valor
      t.integer :parcelas
      t.date :data_contrato

      t.timestamps
    end

    add_foreign_key :contracts, :users, column: :client_id
  end
end
