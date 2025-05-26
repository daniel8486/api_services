class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :cnpj, presence: true, uniqueness: true, format: { with: /\A\d{14}\z/, message: "Deve conter exatamente 14 dígitos numéricos." }
end
