class Neighborhood < ApplicationRecord
  belongs_to :city
  has_many :zips, dependent: :destroy
end
