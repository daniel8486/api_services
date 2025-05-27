class CreateDependents < ActiveRecord::Migration[8.0]
  def change
    create_table :dependents do |t|
      t.string :name
      t.string :cpf
      t.date :dt_born

      t.timestamps
    end
  end
end
