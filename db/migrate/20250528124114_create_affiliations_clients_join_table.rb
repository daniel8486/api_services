class CreateAffiliationsClientsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :affiliations, :clients do |t|
      t.index :affiliation_id
      t.index :client_id
    end
  end
end
