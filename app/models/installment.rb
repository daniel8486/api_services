class Installment < ApplicationRecord
  belongs_to :contract
  has_many :cash_register_transactions

  enum :status, { pendente: "pendente", paga: "paga", atrasada: "atrasada" }
end
