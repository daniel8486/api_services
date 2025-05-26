class Zip < ApplicationRecord
  belongs_to :neighborhood, optional: true
  belongs_to :city, optional: true
  # delegate :city, to: :neighborhood
end
