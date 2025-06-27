class CampaignSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :discount_percentage, :payment_method

  belongs_to :company
  belongs_to :plan, optional: true
  has_many :contracts
end
