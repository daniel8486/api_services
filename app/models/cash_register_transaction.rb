class CashRegisterTransaction < ApplicationRecord
  belongs_to :cash_register
  belongs_to :installment
  belongs_to :client
end
