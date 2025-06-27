class Plan < ApplicationRecord
  belongs_to :company
  has_many :contracts
  has_many :campaigns
end
