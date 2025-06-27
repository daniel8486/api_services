class PlanSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description

  belongs_to :company
  has_many :contracts
  has_many :campaigns
end
