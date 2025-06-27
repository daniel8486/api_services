class PendingImportTable < ApplicationRecord
  belongs_to :user
  validates :table_name, :schema, :expires_at, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
