class ClientSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :cpf, :rg, :dt_expedition, :organ, :phone, :cellphone, :dt_born, :nationality

  has_many :dependents
  has_many :affiliations, serializer: AffiliationSerializer
  has_many :addresses
  has_many :documents
  belongs_to :company
end
