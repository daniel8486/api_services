class AddDegreeDependentIdToDependents < ActiveRecord::Migration[8.0]
  def change
    add_reference :dependents, :degree_dependent, null: false, foreign_key: true
  end
end
