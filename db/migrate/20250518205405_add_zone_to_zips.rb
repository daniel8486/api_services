class AddZoneToZips < ActiveRecord::Migration[8.0]
  def change
    add_column :zips, :zone, :string
  end
end
