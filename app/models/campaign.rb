class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :plan, optional: true
  has_many :contracts

  enum :payment_method, {
    pix: "pix",
    boleto: "boleto",
    credito: "credito",
    debito: "debito"
    # adicione outras formas conforme necessário
  }
end
