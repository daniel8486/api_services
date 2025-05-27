class AddReferencesToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_reference :addresses, :client, null: false, foreign_key: true
  end
end
