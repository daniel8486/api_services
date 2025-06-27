class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :cpf, :role, :avatar
  belongs_to :company, serializer: CompanySerializer

  attribute :adimplencia, if: Proc.new { |user| user.client? }
  attribute :inadimplencia, if: Proc.new { |user| user.client? }
end
