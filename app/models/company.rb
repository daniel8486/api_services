class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :cnpj, presence: true, uniqueness: true, format: { with: /\A\d{14}\z/, message: "Deve conter exatamente 14 dígitos numéricos." }

  has_many :clients, dependent: :destroy

  has_many :plans
  has_many :campaigns
  has_many :contracts
end
