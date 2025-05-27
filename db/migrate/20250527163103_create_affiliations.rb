class CreateAffiliations < ActiveRecord::Migration[8.0]
  def change
    create_table :affiliations do |t|
      t.string :nm_mother
      t.string :nm_father

      t.timestamps
    end
  end
end
