class ContractSerializer
  include JSONAPI::Serializer
  attributes :id, :client_id, :company_id, :plan_id, :campaign_id, :details, :valor, :parcelas, :data_contrato, :parcelas_json

  belongs_to :client, serializer: UserSerializer
  belongs_to :plan
  belongs_to :campaign, optional: true
  belongs_to :company
end
