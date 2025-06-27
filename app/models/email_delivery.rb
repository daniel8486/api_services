class EmailDelivery < ApplicationRecord
  belongs_to :client
  belongs_to :contract

  enum :status, { pending: 0, delivered: 1, failed: 2 }
end
