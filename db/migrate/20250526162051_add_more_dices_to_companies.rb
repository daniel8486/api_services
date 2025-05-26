class AddMoreDicesToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :name_fantasy, :string
    add_column :companies, :size, :string
    add_column :companies, :registration_status_date, :string
    add_column :companies, :opening_date, :string
    add_column :companies, :public_place, :string
    add_column :companies, :number, :integer
    add_column :companies, :complement, :string
    add_column :companies, :code_postal, :string
    add_column :companies, :neighborhood, :string
    add_column :companies, :municipality, :string
    add_column :companies, :uf, :string
    add_column :companies, :email, :string
    add_column :companies, :phone, :string
  end
end
