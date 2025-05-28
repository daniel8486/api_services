class AddressSerializer
  include JSONAPI::Serializer
  attributes :id, :code_postal, :neighborhood, :city, :state, :street, :complement, :point_reference, :number
end
