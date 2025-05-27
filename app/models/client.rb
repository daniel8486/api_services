class Client < ApplicationRecord
  has_one :affiliation, dependent: :destroy
  accepts_nested_attributes_for :affiliation

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  has_many :dependents, dependent: :destroy
  accepts_nested_attributes_for :dependents, allow_destroy: true
end
