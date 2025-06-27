class ContractSendClientContractEmail
  def initialize(contract)
    @contract = contract
    @client = contract.client
  end

  def send_contract_email
    # Aqui também pode customizar por empresa
    CustomWelcomeClientMailer.contract_email(@client, @contract).deliver_now
  end
end
