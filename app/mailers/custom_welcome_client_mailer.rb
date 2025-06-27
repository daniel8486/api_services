class CustomWelcomeClientMailer < ApplicationMailer
   default from: "danielmatos404@gmail.com"
   def contract_email(client, contract)
   Rails.logger.info "Enviando e-mail para #{client.email} com contrato #{contract.id}"
    @client = client
    @contract = contract
    attachments["contrato_#{contract.id}.pdf"] = contract.generate_pdf
    mail(to: @client.email, subject: "Seu contrato foi gerado!")
   end
end
