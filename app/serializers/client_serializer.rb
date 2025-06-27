class ClientSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :cpf, :rg, :dt_expedition, :organ, :phone, :cellphone, :dt_born, :nationality

  has_many :dependents, serializer: DependentSerializer
  has_many :affiliations, serializer: AffiliationSerializer
  has_many :addresses, serializer: AddressSerializer
  has_many :documents, serializer: DocumentSerializer
  belongs_to :company
end
