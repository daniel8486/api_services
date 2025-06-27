class Contract < ApplicationRecord
  belongs_to :client# , class_name: "User"
  belongs_to :plan
  belongs_to :campaign, optional: true
  has_many :installments
  belongs_to :company

  def gerar_parcelas!
    return if data_contrato.blank? || parcelas.blank? || valor.blank?

    valor_parcela = (valor / parcelas).round(2)
    data = data_contrato.to_date

    parcelas.times do |i|
      vencimento = (i == 0 ? data : data.advance(months: i))
      vencimento += 1.day while vencimento.saturday? || vencimento.sunday?
      installments.create!(
        numero: i + 1,
        valor: valor_parcela,
        vencimento: vencimento,
        status: "pendente" # ou outro valor padrão para status
      )
    end
  end

  def parcelas_json
    return [] unless data_contrato && parcelas && valor

    valor_parcela = (valor / parcelas).round(2)
    datas = []
    data = data_contrato.to_date

    parcelas.times do |i|
      vencimento = (i == 0 ? data : data.advance(months: i))
      # Pula para o próximo dia útil se cair sábado ou domingo
      vencimento += 1.day while vencimento.saturday? || vencimento.sunday?
      datas << {
        numero: i + 1,
        valor: valor_parcela,
        vencimento: vencimento # .strftime("%d/%m/%Y")
      }
    end
    datas
  end

  def generate_pdf
    ContractPdfsService.new(self).generate
  end
end
