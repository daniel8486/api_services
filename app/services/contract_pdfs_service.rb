require "prawn/table"

class ContractPdfsService
    def initialize(contract)
      @contract = contract
    end

    def generate
    
      case @contract.company.try(:slug) 
      when "empresa_x"
        generate_empresa_x_pdf
      else
        generate_default_pdf
      end
    end

    private

    def generate_default_pdf
        Prawn::Document.new do |pdf|
      # logo_path = Rails.root.join("app/assets/images/logo.png")
      # pdf.image logo_path, width: 100 if File.exist?(logo_path)
      # pdf.move_down 10

      # Cabeçalho
      pdf.text "CONTRATO DE PRESTAÇÃO DE SERVIÇOS", size: 18, style: :bold, align: :center
      pdf.move_down 20

      # Dados principais
      pdf.text "Número do Contrato: #{@contract.id}", style: :bold
      pdf.text "Cliente: #{@contract.client.try(:name) || @contract.client_id}"
      pdf.text "Empresa: #{@contract.company.try(:name) || @contract.company_id}"
      pdf.text "Plano: #{@contract.plan.try(:name) || @contract.plan_id}"
      pdf.text "Valor Total: R$ #{'%.2f' % @contract.valor}"
      pdf.text "Parcelas: #{@contract.parcelas}"
      pdf.text "Detalhes: #{@contract.details}"
      pdf.move_down 10

      # Tabela de parcelas
      if @contract.respond_to?(:parcelas_json) && @contract.parcelas_json.any?
        pdf.text "Parcelas:", style: :bold
        data = [ [ "Nº", "Valor", "Vencimento" ] ]
        @contract.parcelas_json.each do |parcela|
          data << [
            parcela[:numero],
            "R$ #{'%.2f' % parcela[:valor]}",
            I18n.l(parcela[:vencimento], format: :short)
          ]
        end
        pdf.table(data, header: true, width: pdf.bounds.width)
        pdf.move_down 10
      end

      # Rodapé
      pdf.move_down 30
      pdf.text "Data de geração: #{I18n.l(Time.current, format: :short)}", size: 10, align: :right
      pdf.move_down 10
      pdf.text "Assinatura do Cliente: ____________________________", size: 12
      pdf.move_down 5
      pdf.text "Assinatura da Empresa: ____________________________", size: 12
     end.render
    end

    def generate_empresa_x_pdf
      Prawn::Document.new do |pdf|
        # ...layout customizado para empresa_x...
        pdf.text "CONTRATO PERSONALIZADO EMPRESA X", size: 18, style: :bold, align: :center
        # ...restante do código...
      end.render
    end
end
