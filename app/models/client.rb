class Client < ApplicationRecord
  has_many :affiliations
  accepts_nested_attributes_for :affiliations, allow_destroy: true

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  has_many :dependents, dependent: :destroy
  accepts_nested_attributes_for :dependents, allow_destroy: true

  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents, allow_destroy: true

  belongs_to :company

  has_many :contracts
  has_many :cash_register_transactions

  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "Must contain exactly 11 numeric digits." }
end
