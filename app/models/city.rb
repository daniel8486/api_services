class City < ApplicationRecord
  belongs_to :state, optional: false
  has_many :neighborhoods
  has_many :zips, through: :neighborhoods

  validates :name, presence: true
  validates :state, presence: true  # ou state_id
end
