class AddReferencesToAffiliations < ActiveRecord::Migration[8.0]
  def change
    add_reference :affiliations, :client, null: false, foreign_key: true
  end
end
