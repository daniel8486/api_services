class CreateAccessLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :access_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip
      t.string :region
      t.datetime :accessed_at

      t.timestamps
    end
  end
end
