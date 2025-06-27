class SendClientContractEmailJob < ApplicationJob
   queue_as :send_client_contract_email

   def perform(client_id, contract_id)
     client = Client.find(client_id)
     contract = Contract.find(contract_id)
     return unless client && contract

     CustomWelcomeClientMailer.contract_email(client, contract).deliver_now
   end
end
