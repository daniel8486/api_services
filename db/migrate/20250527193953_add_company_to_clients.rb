class AddCompanyToClients < ActiveRecord::Migration[8.0]
  def change
    # add_reference :clients, :company, null: false, foreign_key: true
  end
end
