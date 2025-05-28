class AffiliationSerializer
  include JSONAPI::Serializer
  attributes :id, :nm_mother, :nm_father

  belongs_to :client
end
