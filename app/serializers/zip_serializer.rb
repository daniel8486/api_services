class ZipSerializer
  include JSONAPI::Serializer
  attributes :id, :code, :street, :neighborhood_id, :city_id, :zone, :created_at, :updated_at

  belongs_to :neighborhood
  belongs_to :city
end
