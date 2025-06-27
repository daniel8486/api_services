class AddStatusToEmailDelivery < ActiveRecord::Migration[8.0]
  def change
    add_column :email_deliveries, :status, :integer
    add_column :email_deliveries, :error_message, :string
  end
end
