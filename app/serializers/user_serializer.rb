class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :cpf, :role, :avatar
  belongs_to :company
end
